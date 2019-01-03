//
// Created by Vladislav Kasatkin on 2019-01-03.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct FilterData: Decodable {
    var categories: [FilterDataItem] = []
    var districts: [FilterDataItem] = []
}


struct FilterDataItem: Decodable {
    var id: Int?
    var name: String?
}