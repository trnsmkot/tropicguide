//
// Created by Vladislav Kasatkin on 2019-01-01.
// Copyright (c) 2019 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct CommonDesc: Decodable {
    var id: Int?
    var name: String?
    var shortDescription: String?
    var descriptions: [CommonDescription]?
}