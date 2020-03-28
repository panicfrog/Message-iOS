//
//  Websocket.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2020/3/27.
//  Copyright © 2020 Yeyongping. All rights reserved.
//
import Starscream
import Foundation

protocol WebsocketDelegate {
    func receive(message: ChatMessage, from websocket: WS)
}

final class WS {
    static let shared = WS()
    
    enum WebsocketError: Error {
        case duplicateDelegateKey
        case inviteDeletateKey
    }
    
    private enum CasheableMessage {
        case noCasheableMessage(message: ChatMessage)
        case cashedMessage(message: ChatMessage)
    }
    
//    private let socket = Starscream.WebSocket
    
    private var cacheTasks = [ChatMessage]()
    private var waitingTasks = [CasheableMessage]()
    private let messageQueue = DispatchQueue(label: "com.yongping.messageQueue")
    private var websocketDelegates = [String: WebsocketDelegate]()
    
    lazy var pingTimer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 5)
        t.setEventHandler {[unowned self] in
            guard self.websocketTask.state != .running else {
                return
            }
            self.websocketTask.sendPing { err in
                guard let e = err else {
                    return
                }
                print(e)
            }
        }
        return t
    }()
    
    lazy var checkTimer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 0.5)
        t.setEventHandler {[unowned self] in
            guard self.websocketTask.state != .running else {
                return
            }
            guard let first = self.waitingTasks.first else {
                return
            }
            let message: ChatMessage
            let needResume: Bool
            switch first {
            case .cashedMessage(let msg):
                message = msg
                needResume = true
            case .noCasheableMessage(let msg):
                message = msg
                needResume = false
            }
            
            self.messageQueue.async {[unowned self] in
                guard
                    let dataMsg = try? JSONEncoder().encode(message),
                    let strMsg = String(data: dataMsg, encoding: .utf8)
                    else {
                        print("decode message error")
                        return
                }
                
                self.websocketTask.send(.string(strMsg)) {[unowned self] (err) in
                    guard err == nil, needResume else {
                        if let e = err {
                            print(e)
                        }
                        return
                    }
                    self.cacheTasks.append(message)
                }
            }
            
        }
        return t
    }()
    
    func connect(){
        self.websocketTask.resume()
        //        messageQueue.async {[unowned self] in
        //            self.websocketTask.resume()
        //            self.pingTimer.resume()
        //            self.checkTimer.resume()
        //        }
        self.receiveMessage()
    }
    
    func reconnect() {
        messageQueue.async {[unowned self] in
            self.websocketTask.resume()
            self.pingTimer.resume()
            self.checkTimer.resume()
        }
        for t in self.cacheTasks {
            self.sendMessage(t)
        }
        receiveMessage()
    }
    
    func sendMessage(_ msg: ChatMessage, needResume: Bool = false) {
        self.messageQueue.sync {
            if needResume {
                self.waitingTasks.append(.cashedMessage(message: msg))
            } else {
                self.waitingTasks.append(.noCasheableMessage(message: msg))
            }
        }
    }
    
    func add(delegate: WebsocketDelegate, with identifier: String) throws {
        try messageQueue.sync {[unowned self] in
            if let _ = websocketDelegates[identifier] {
                throw WebsocketError.duplicateDelegateKey
            }
            self.websocketDelegates[identifier] = delegate
        }
    }
    
    func remove(delegate: WebsocketDelegate, with identifiable: String) throws {
        try messageQueue.sync {[unowned self] in
            guard let _ = self.websocketDelegates.removeValue(forKey: identifiable) else {
                throw WebsocketError.inviteDeletateKey
            }
        }
    }
    
    func receiveMessage() {
        self.websocketTask.receive {[unowned self] (res) in
            print("websocket message: ", res)
            switch res {
            case .success(let msg):
                self.messageQueue.async {[unowned self] in
                    guard case URLSessionWebSocketTask.Message.string(let msg) = msg else {
                        return
                    }
                    guard let data = msg.data(using: .utf8) else {
                        return
                    }
                    guard let m = try? JSONDecoder().decode(ChatMessage.self, from: data) else {
                        return
                    }
                    for d in self.websocketDelegates.values {
                        d.receive(message: m, from: self)
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
