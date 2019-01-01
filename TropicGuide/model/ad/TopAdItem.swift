//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct TopAdItem: Decodable {

    var id: Int?
    var title: String?
    var link: String?
    var parentId: Int?
    var image: String?
    var type = Type.TOUR
    var sortOrder: Int = 0
}

enum Type: String, Decodable {
    case TOUR, POINT, LINK
}