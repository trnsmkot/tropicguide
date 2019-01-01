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

class TopAdViewModal {

    static let shared = TopAdViewModal()
    let apiProvider = CommonAPIProvider()
    let disposeBag = DisposeBag()

    init() {
    }

    func getAdsById(_ id: Int) -> Observable<ServerResponse<[TopAdItem]>>? {
        return apiProvider.getTopAdsById(id)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }
}
