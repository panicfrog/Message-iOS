//
//  ChatModel.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI
import Combine

let tokenKey = "message.yeyongping.tokenKey"

final class ChatViewModel: ObservableObject {
    @Published private(set) var logined: Bool = false
    
    init() {
        // TODO - realy login token
        if UserDefaults.standard.string(forKey: tokenKey) == .none {
            storeToken(token: "faker token")
        }
        
        guard let _ = UserDefaults.standard.string(forKey: tokenKey) else {
            logined = false
            return
        }
        logined = true
        
        WS.shared.connect()
        do {
            try WS.shared.add(delegate: self, with: "12443")
        } catch {
            print(error)
        }
        
    }
    
    func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.synchronize()
        logined = true
    }
    
    func deleToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.synchronize()
        logined = false
    }
}

extension ChatViewModel: WSDelegate {
    func onMessage(message: ChatMessage, from websocket: WS) {
        
    }
    
    func onError(error: Error, from websocket: WS) {
        
    }
    
    func onOpen() {
        
    }
    
    func onClose() {
        
    }
}
