//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct TourItemDesc: Decodable {
    var name: String?

    var whatIncluded: String?
    var whatNotIncluded: String?
    var whatTakeWithMe: String?

    var description: String?
    var shortDescription: String?
    var showAlert: Bool?
    var alertInfo: String?

    var programs: [TourItemProgram]? = []
}