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

class TourViewModal {

    static let shared = TourViewModal()
    var categories: Observable<ServerResponse<[TourCategory]>>
    let apiProvider = CommonAPIProvider()
    let disposeBag = DisposeBag()
    
    init() {
        categories = apiProvider.getTourCategories()
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)


    }

    func getToursByCategory(id: Int?) -> Observable<ServerResponse<[TourItem]>>? {
        if let id = id {
            return apiProvider.getToursByCategory(id: id)
                    .observeOn(MainScheduler.instance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .share(replay: 1)
        } else {
            return nil
        }
    }
}
