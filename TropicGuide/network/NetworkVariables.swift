//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

struct NetworkVariables {

//    private static let BASE_URL = "http://localhost:9000/remote/api/v1/"
    private static let BASE_URL = "http://tropicguide.info/remote/api/v1/"
    private static let BASE_TOUR_URL = "https://phuket-tropic-tours.com/remote/api/v1/"
//    private static let BASE_TOUR_URL = "http://localhost:9000/remote/api/v1/"
    private static let APP_LANG = "en"


    static let TOUR_CATEGORIES_URL = "\(BASE_TOUR_URL)categories/"

    static func getToursURLByCategory(id: Int) -> String {
        return "\(BASE_TOUR_URL)tours/\(id)/"
    }

    static func getTourURLById(id: Int) -> String {
        return "\(BASE_TOUR_URL)tour/\(id)/"
    }

    static let SEND_REQUEST_TOUR_URL = "\(BASE_URL)booking/\(APP_LANG)/send/"


    static func getInfoCategories(parentId: Int) -> String {
        return "\(BASE_URL)info/categories/\(APP_LANG)/\(parentId)/"
    }

    static func getInfosURLByCategory(id: Int) -> String {
        return "\(BASE_URL)info/list/\(APP_LANG)/\(id)/"
    }

    static func getInfoURLByInfo(id: Int) -> String {
        return "\(BASE_URL)info/info/\(APP_LANG)/\(id)/"
    }


    static func getTopAdsURLByIdy(_ id: Int) -> String {
        return "\(BASE_URL)favorites/\(APP_LANG)/\(id)/"
    }


    static let DISTRICTS_URL = "\(BASE_URL)districts/\(APP_LANG)/"


    static let POINT_CATEGORIES_URL = "\(BASE_URL)categories/\(APP_LANG)/"
    static let TOP_CATEGORIES_URL = "\(BASE_URL)topcategories/\(APP_LANG)/"

    static func getPointsURL(categoryId: Int, page: Int) -> String {
        return "\(BASE_URL)points/\(APP_LANG)/\(categoryId)/\(page)/"
    }

    static func getPointUrlByPoint(id: Int) -> String {
        return "\(BASE_URL)point/\(APP_LANG)/\(id)/"
    }


    static let MAP_POiNTS_URL = "\(BASE_URL)map/points/\(APP_LANG)/"


    static let FILTER_SETTINGS_URL = "\(BASE_URL)map/index/\(APP_LANG)/"

}
