//
//  TabBarItemView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI
import Foundation

struct TabBarItemView: View {
    let iconName: String
    let title: String
    var body: some View {
        VStack {
            Image(systemName: iconName)
            Text(title)
        }
    }
    func some() {
        
    }
}

struct TabBarItemView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
