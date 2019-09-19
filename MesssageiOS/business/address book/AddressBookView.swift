//
//  AddressBookView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct AddressBookView: View {
    var body: some View {
            NavigationView{
            VStack {
                NavigationLink(destination: ChatDetailView()) {
                    Text("address book view")
                }
            }.navigationBarTitle("address book")
        }
    }
}

#if DEBUG
struct AddressBookView_Preview: PreviewProvider {
    static var previews: some View {
        return AddressBookView()
    }
}

#endif
