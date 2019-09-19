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
}

extension ChatApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
           switch self {
               case .login:
                   return Moya.Method.post
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
        }
        return params
    }
}
