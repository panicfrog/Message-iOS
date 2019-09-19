//
//  SettingView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var chatModel: ChatModel
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("profile")
                    .resizable()
                        .frame(width: CGFloat(80), height: CGFloat(80))
                        .cornerRadius(40)
                    VStack(spacing: 5) {
                        HStack {
                            Text("姓名: xxx").fontWeight(.heavy)
                            Spacer()
                        }
                        HStack {
                            Text("个人信息")
                            Spacer()
                            Text("二维码")
                        }
                    }
                }.padding()
                List {
                    SettingRowView(title: "其他") {
                        print("其他")
                    }
                    SettingRowView(title: "退出") {
                        self.chatModel.deleToken()
                    }
                }
            }.navigationBarTitle("设置")
        }
    }
}

#if DEBUG
struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        UITableView.appearance().separatorColor = .clear
        return SettingView().environmentObject(ChatModel())
    }
}

#endif
