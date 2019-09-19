//
//  ChatView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/11.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
            NavigationView{
            VStack {
                NavigationLink(destination: ChatDetailView()) {
                    Text("chat view")
                }
            }.navigationBarTitle("聊天")
        }
    }
}

#if DEBUG
struct Chatview_Preview: PreviewProvider {
    static var previews: some View {
        return ChatView()
    }
}

#endif
