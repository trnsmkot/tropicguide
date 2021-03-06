//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct InfoItem: Decodable {
    var id: Int?
    var sortOrder: Int = 0
    var timestamp: Int?
    var cover: String?
    var desc: CommonDesc?
}
