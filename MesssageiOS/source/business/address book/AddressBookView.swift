//
//  AddressBookView.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI
import Combine

struct AddressBookView: View {
    @ObservedObject var addressModel = AddressModel()
    var body: some View {
        NavigationView{
            List {
                Section(header: Text("好友")) {
                    ForEach(self.addressModel.friends, id: \.account) { a in
                        NavigationLink(destination: ChatDetailView()) {
                            Text("\(a.account)")
                        }
                    }
                }
                Section(header: Text("群组")) {
                    ForEach(self.addressModel.rooms, id: \.room_identifier) { r in
                        NavigationLink(destination: ChatDetailView()) {
                            Text("\(r.room_name)")
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
                .navigationBarTitle("通讯录")
            }
        .onAppear {
            self.addressModel.queryFriends()
            self.addressModel.queryRooms()
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
