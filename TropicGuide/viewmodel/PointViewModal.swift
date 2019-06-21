//
//  PointViewModal.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 30/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PointViewModal {

    static let shared = PointViewModal()
    let apiProvider = CommonAPIProvider()

    func getDistricts() -> Observable<ServerResponse<[District]>>? {
        return apiProvider.getDistricts()
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }

    func getPointCategories() -> Observable<ServerResponse<[PointCategory]>>? {
        return apiProvider.getPointCategories()
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }

    func getPointsByData(categoryId: Int) -> Observable<ServerResponse<[PointItemShort]>>? {
        return apiProvider.getPointsByData(categoryId: categoryId)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }

    func getPointByPoint(id: Int?) -> Observable<ServerResponse<PointItem?>>? {
        if let id = id {
            return apiProvider.getPointByPoint(id: id)
                    .observeOn(MainScheduler.instance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .share(replay: 1)
        } else {
            return nil
        }
    }
}
