//
// Created by Vladislav Kasatkin on 2019-01-03.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

class PointFilter {
    var query: String?
    var categories: [Int] = []
    var districts: [Int] = []


    func active() -> Bool {
        if let query = query, query.count > 0 {
            return true
        }
        if (categories.count > 0 || districts.count > 0) {
            return true
        }
        return false
    }
}