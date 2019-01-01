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

    static let INFO_CATEGORIES_URL = "\(BASE_URL)info/categories/\(APP_LANG)/"
    static func getInfosURLByCategory(id: Int) -> String {
        return "\(BASE_URL)info/list/\(APP_LANG)/\(id)/"
    }
    static func getInfoURLByInfo(id: Int) -> String {
        return "\(BASE_URL)info/info/\(APP_LANG)/\(id)/"
    }

    static func getTopAdsURLByIdy(_ id: Int) -> String {
        return "\(BASE_URL)favorites/\(APP_LANG)/\(id)/"
    }
}