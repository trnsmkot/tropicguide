//
// Created by Vladislav Kasatkin on 2019-01-01.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct PointItemShort: Decodable {
    var id: Int?
    var sortOrder: Int = 0
    var cover: String?
    var district: String?
    var name: String?
    var markerIcon: String?
    var lat: Double = 0.0
    var lng: Double = 0.0
    var type: PointItem.PointType?
}
