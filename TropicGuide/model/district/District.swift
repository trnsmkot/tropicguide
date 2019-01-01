//
// Created by Vladislav Kasatkin on 2019-01-01.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct District: Decodable {
    var id: Int?
    var sortOrder: Int = 0
    var cover: String?
    var desc: CommonDesc?
}