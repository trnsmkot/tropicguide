//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct NetworkVariables {

    private static let BASE_URL = "http://tropicguide.info/remote/api/v1/"
    private static let APP_LANG = "ru"


    static let TOUR_CATEGORIES_URL = "\(BASE_URL)tour/categories/\(APP_LANG)/"

    static func getToursURLByCategory(id: Int) -> String {
        return "\(BASE_URL)tours/\(APP_LANG)/\(id)/"
    }
}