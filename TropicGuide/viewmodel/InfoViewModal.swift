//
//  TourViewModal.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 30/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class InfoViewModal {

    static let shared = InfoViewModal()
    let apiProvider = CommonAPIProvider()

    func getInfoCategories(parentId: Int) -> Observable<ServerResponse<[InfoCategory]>>? {
        return apiProvider.getInfoCategories(parentId: parentId)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }

    func getInfosByCategory(id: Int?) -> Observable<ServerResponse<[InfoItem]>>? {
        if let id = id {
            return apiProvider.getInfosByCategory(id: id)
                    .observeOn(MainScheduler.instance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .share(replay: 1)
        } else {
            return nil
        }
    }

    func getInfoByInfo(id: Int?) -> Observable<ServerResponse<InfoItem?>>? {
        if let id = id {
            return apiProvider.getInfosByInfo(id: id)
                    .observeOn(MainScheduler.instance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .share(replay: 1)
        } else {
            return nil
        }
    }
}
