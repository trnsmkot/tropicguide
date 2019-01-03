//
//  FilterViewModal.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 30/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FilterViewModal {

    static let shared = FilterViewModal()
    let apiProvider = CommonAPIProvider()


    func getFilterData() -> Observable<ServerResponse<FilterData?>>? {
        return apiProvider.getFilterData()
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .share(replay: 1)
    }


}
