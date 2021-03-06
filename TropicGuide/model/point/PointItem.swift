//
// Created by Vladislav Kasatkin on 2019-01-01.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct PointItem: Decodable {
    var id: Int?
    var sortOrder: Int = 0
    var cover: String?
    var markerIcon: String?
    var lat: Double = 0.0
    var lng: Double = 0.0
    var category: PointCategory?
    var zoom: Float = 0
    var images: [PointImage]?
    var reviews: Int = 0
    var views: Int = 0

    var type: PointType?

    var name: String?
    var text: String?
    var descriptions: [CommonDescription]?

    enum PointType: String, Decodable {
        case POINT, POST
    }
}