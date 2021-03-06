//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct InfoCategory: Decodable {
    var id: Int?
    var sortOrder: Int = 0
    var name: String?
    var icon: String?
    var total: Int = 0
    var allCatId: Int = 0
}
