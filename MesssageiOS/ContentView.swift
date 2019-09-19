//
//  ContentVIew.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var chatModel: ChatModel
    var body: some View {
        Group {
            if chatModel.logined {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}


#if DEBUG
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(ChatModel())
    }
}

#endif
