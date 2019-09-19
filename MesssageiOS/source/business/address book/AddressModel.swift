//
//  AddressModel.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/19.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import Combine

class AddressModel: ObservableObject {
    @Published var friends = [User]()
    @Published var rooms = [RoomBrief]()
    func queryFriends() {
        requestUserFriends { (result) in
            switch result {
            case .success(let users):
                self.friends = users
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func queryRooms() {
        requestUserRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
            case .failure(let err):
                print(err)
            }
        }
    }
}
