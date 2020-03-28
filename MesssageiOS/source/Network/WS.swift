//
//  Websocket.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2020/3/27.
//  Copyright © 2020 Yeyongping. All rights reserved.
//
import Starscream
import Foundation

protocol WSDelegate {
    func onMessage(message: ChatMessage, from websocket: WS)
    func onError(error: Error, from websocket: WS)
    func onOpen()
    func onClose()
}

final class WS: NSObject, WebSocketDelegate {
    
    static let shared = WS()
    
    enum WebsocketError: Error {
        case duplicateDelegateKey
        case inviteDeletateKey
    }
    
    private enum CasheableMessage {
        case noCasheableMessage(message: ChatMessage)
        case cashedMessage(message: ChatMessage)
    }
    
    
    private(set) var socket =  WebSocket(request: URLRequest(url: URL(string: "ws://localhost:8080/ws")!))

    private(set) var isConnected = false
    
    private var cacheTasks = [ChatMessage]()
    private var waitingTasks = [CasheableMessage]()
    private let messageQueue = DispatchQueue(label: "com.yongping.messageQueue")
    private var websocketDelegates = [String: WSDelegate]()
    private let semaphore = DispatchSemaphore(value: 1)
    
    lazy var checkTimer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 0.1)
        t.setEventHandler {[unowned self] in
            
            guard self.isConnected else {
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
            guard
                let dataMsg = try? JSONEncoder().encode(message),
                let strMsg = String(data: dataMsg, encoding: .utf8)
                else {
                    print("decode message error")
                    return
            }
            
            self.socket.write(string: strMsg) {[unowned self] in
                self.messageQueue.async {[unowned self] in
                    self.semaphore.wait()
                    self.waitingTasks.removeFirst()
                    self.semaphore.signal()
                }
                guard needResume else {
                    return
                }
                self.semaphore.wait()
                self.cacheTasks.append(message)
                self.semaphore.signal()
            }
        }
        return t
    }()
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected:
            messageQueue.async {[unowned self] in
                self.isConnected = true
                for d in self.websocketDelegates.values {
                    d.onOpen()
                }
            }
            break
        case .disconnected(_, _):
            messageQueue.async {[unowned self] in
                self.isConnected = false
                for d in self.websocketDelegates.values {
                    d.onClose()
                }
            }
        case .text(let msg):
            print(msg)
            messageQueue.async {[unowned self] in
                guard let data = msg.data(using: .utf8) else {
                    return
                }
                guard let m = try? JSONDecoder().decode(ChatMessage.self, from: data) else {
                    return
                }
                for d in self.websocketDelegates.values {
                    d.onMessage(message: m, from: self)
                }
            }
        case .binary(_):
            break
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(let err):
            messageQueue.async {[unowned self] in
                self.isConnected = false
                guard let err = err else {
                    return
                }
                for d in self.websocketDelegates.values {
                    d.onError(error: err, from: self)
                }
            }
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            messageQueue.async {[unowned self] in
                self.isConnected = false
            }
        }
    }
    
    func connect(){
        socket.respondToPingWithPong = true
        socket.delegate = self
        socket.connect()
        self.checkTimer.resume()
    }
    
    func disconnect() {
        self.socket.disconnect()
        self.socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:8080/ws")!))
    }
    
    func reconnect() {
        messageQueue.async {[unowned self] in
            self.socket.connect()
            self.checkTimer.resume()
            for t in self.cacheTasks {
                self.sendMessage(t)
            }
        }
    }
    
    func sendMessage(_ msg: ChatMessage, needResume: Bool = false) {
        messageQueue.sync {[unowned self] in
            self.semaphore.wait()
            if needResume {
                self.waitingTasks.append(.cashedMessage(message: msg))
            } else {
                self.waitingTasks.append(.noCasheableMessage(message: msg))
            }
            self.semaphore.signal()
        }
    }
    
    func add(delegate: WSDelegate, with identifier: String) throws {
        try messageQueue.sync {[unowned self] in
            if let _ = websocketDelegates[identifier] {
                throw WebsocketError.duplicateDelegateKey
            }
            self.websocketDelegates[identifier] = delegate
        }
    }
    
    func remove(delegate: WSDelegate, with identifiable: String) throws {
        try messageQueue.sync {[unowned self] in
            guard let _ = self.websocketDelegates.removeValue(forKey: identifiable) else {
                throw WebsocketError.inviteDeletateKey
            }
        }
    }
    
}
