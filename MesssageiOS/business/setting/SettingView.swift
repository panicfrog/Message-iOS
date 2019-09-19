//
//  SettingView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
            NavigationView{
            VStack {
                NavigationLink(destination: ChatDetailView()) {
                    Text("setting view")
                }
            }.navigationBarTitle("setting")
        }
    }
}

#if DEBUG
struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        return SettingView()
    }
}

#endif
