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
    @Published private(set) var logined: Bool = false
    
    init() {
        logined = UserDefaults.standard.bool(forKey: "logined")
    }
    
    func toggleLogined() {
        let _isLogined = !logined
        UserDefaults.standard.set(_isLogined, forKey: "logined")
        UserDefaults.standard.synchronize()
        logined = _isLogined
    }
}
