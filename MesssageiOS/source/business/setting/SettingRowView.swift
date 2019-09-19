//
//  SettingRowView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct SettingRowView: View {
    let title: String
    let action: () -> Void
    var body: some View {
            Button(action: self.action) {
                Text(self.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#if DEBUG
struct SettingRowView_Preview: PreviewProvider {
    static var previews: some View {
        UITableView.appearance().separatorColor = .clear
        return SettingRowView(title: "标题") {
            print("hello")
        }
    }
}
#endif
