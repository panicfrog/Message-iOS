//
//  ApiStatus.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import Foundation
import Moya

/*
 ApiStatusSuccess            ApiStatus = 0
 ApiStatusFailed             ApiStatus = 1
 ApiStatusParamsError        ApiStatus = 2
 ApiStatusInternelError      ApiStatus = 3
 ApiStatusUnauthUnauthorized ApiStatus = 4
 ApiStatusTokenUnknowErr     ApiStatus = 5
 */

enum ApiError: Error {
    case moyaError(err: MoyaError)
    case apiStatusFailed(reason: String)
    case apiParamsError
    case apiServiceError
    case apiUnauthorizedError
    case apiTokenUnknowError
    case apiDeserializeError
}
