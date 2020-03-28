//
//  MainView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            ChatView()
                .tabItem { TabBarItemView(iconName: "message.circle", title: "消息") }
                .tag(0)
            AddressBookView()
                .tabItem { TabBarItemView(iconName: "person.crop.square", title: "通讯录") }
                .tag(1)
            SettingView()
                .tabItem { TabBarItemView(iconName: "gear", title: "设置")  }
                .tag(2)
        }
    }
}

#if DEBUG
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
       UITableView.appearance().separatorColor = .clear
        return MainView().environmentObject(ChatViewModel())
    }
}
#endif
