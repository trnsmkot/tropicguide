//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct CommonDescription: Decodable {
    var title: String?
    var text: String?
    var type: DescType = DescType.TEXT
    var imagePath: String?
    var sortOrder: Int?
}

enum DescType: String, Decodable {
    case TEXT, IMAGE, INSTA
}