//
//  ChatModel.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI
import Combine

final class ChatModel: ObservableObject {
    private let tokenKey = "message.yeyongping.tokenKey"
    @Published private(set) var logined: Bool = false
    
    init() {
        guard let _ = UserDefaults.standard.string(forKey: tokenKey) else {
        logined = false
            return
        }
        logined = true
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
