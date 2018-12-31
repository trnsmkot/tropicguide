//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct TourItem: Decodable {
    var id: Int?
    var name: String?
    var desc: String?
    var cover: String?
    var sortOrder: Int = 0
    var rating: Int?
    var price: String?
    var url: String?
}