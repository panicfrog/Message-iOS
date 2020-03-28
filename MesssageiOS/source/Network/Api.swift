//
//  api.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import Moya

enum ChatApi {
    case login(account: String, passwd: String)
    case userFriends
    case userRooms
}

extension ChatApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.0.112:8080")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .userFriends:
            return "/auth/user/friends"
        case .userRooms:
            return "/auth/user/rooms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return Moya.Method.post
        case .userFriends, .userRooms:
            return Moya.Method.get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        if parameters.count > 0,
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            if self.method == .get {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            }
            return .requestData(data)
        }
        return .requestPlain
    }
    
    
    var headers: [String : String]? {
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            return [
                "Content-Type": "application/json",
                "platform": "ios",
                "token": token
            ]
        }
        return [
            "Content-Type": "application/json",
            "platform": "ios"
        ]
        
    }
    
    var parameters: [String: Any] {
        var params = [String: Any]()
        switch self {
        case .login(let account, let passwd):
            params["account"] = account
            params["passwd"] = passwd
        case .userFriends, .userRooms:
            break
        }
        return params
    }
}
