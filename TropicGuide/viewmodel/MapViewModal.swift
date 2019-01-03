//
//  MapViewModal.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 30/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModal {

    static let shared = MapViewModal()
    let apiProvider = CommonAPIProvider()


    func getMapPointsByData(categories: [Int] = [], districts: [Int] = [], query: String? = nil) -> Observable<ServerResponse<[PointItemShort]>>? {
        return apiProvider.getMapPointsByData(categories: categories, districts: districts, query: query)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }


}
