//
//  ApiModel.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/18.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import Foundation
import HandyJSON

extension String: HandyJSON{}
extension Double: HandyJSON{}

struct BaseResponse: HandyJSON {
    var sc: Int = 0
    var message: String = ""
}

struct ApiResponse<T: HandyJSON>: HandyJSON {
    var sc: Int = 0
    var message: String = ""
    var data: T? = nil
}

struct ApiArrayResponse<T: HandyJSON>: HandyJSON {
    var sc: Int = 0
    var message: String = ""
    var data: [T] = []
}

//-----------------------------------------------------------------------------


