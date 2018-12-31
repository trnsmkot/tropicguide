//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct ServerResponse<ResponseType: Decodable>: Decodable {

    var successful: Bool = true
    var status: Int = 0
    var message: String?
    var data: ResponseType?
}