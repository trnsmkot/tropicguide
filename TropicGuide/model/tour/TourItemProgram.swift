//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct TourItemProgram: Decodable {
    var name: String?
    var description: String?
    var guide: Int = 0
    var longTime: String?

    var schedule: String?
    var showStartTime: Bool = false
    var hidden: Bool = true
    var startTime: String?
    var isPrivate: Bool = false

    var prices: [TourItemProgramPrice] = []
}


struct TourItemProgramPrice: Decodable {
    var price: Int = 0
    var name: String?
}
