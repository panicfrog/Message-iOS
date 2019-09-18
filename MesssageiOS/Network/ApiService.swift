//
//  ApiService.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import Moya
import HandyJSON

fileprivate let provider = MoyaProvider<ChatApi>(manager: DefaultAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(verbose: true)])

fileprivate func query(_ target: ChatApi, completion: @escaping (Result<[String:Any], ApiError>) -> Void) {
    provider.request(target) { (result) in
        switch result {
        case .success(let response):
            guard let json = try? response.mapJSON() as? [String: Any] else {
                return
            }
            guard let code = json["sc"] as? Int, let msg = json["message"] as? String else {
                return
            }
            
            if 0 == code { // 成功
                completion(.success(json))
            } else if 1 == code { // 失败
                completion(.failure(.apiStatusFailed(reason: "\(msg)")))
            } else if 2 == code { // 参数错误
                completion(.failure(.apiParamsError))
            } else if 3 == code { // 服务端错误
                completion(.failure(.apiServiceError))
            } else if 4 == code { // 未授权
                completion(.failure(.apiUnauthorizedError))
            } else if 5 == code { // token异常
                completion(.failure(.apiTokenUnknowError))
            }
            
        case .failure(let err):
            completion(.failure(.moyaError(err: err)))
        }
    }
}

func request(account: String, passwd: String, completion: @escaping ((Result<String, ApiError>) -> Void)) {
    query(.login(account: account, passwd: passwd)) { (result) in
        switch result {
        case .success(let response):
            guard let res = ApiResponse<String>.deserialize(from: response) else {
                completion(.failure(.apiDeserializeError))
                return
            }
            completion(.success(res.data ?? ""))
        case .failure(let err):
            completion(.failure(err))
        }
    }
}
