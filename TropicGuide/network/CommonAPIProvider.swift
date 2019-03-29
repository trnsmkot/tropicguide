//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommonAPIProvider {

    func getTourCategories() -> Observable<ServerResponse<[TourCategory]>> {
        guard let url = URL(string: NetworkVariables.TOUR_CATEGORIES_URL) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([TourCategory].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of tour's categories: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get tour's categories"))
        }
    }

    func getToursByCategory(id: Int) -> Observable<ServerResponse<[TourItem]>> {
        guard let url = URL(string: NetworkVariables.getToursURLByCategory(id: id)) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([TourItem].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of tours by category: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get tours by category"))
        }
    }

    func getTourById(id: Int) -> Observable<ServerResponse<TourItem?>> {
        guard let url = URL(string: NetworkVariables.getTourURLById(id: id)) else {
            return Observable.just(getResponse(nil, 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let item = try JSONDecoder().decode(TourItem.self, from: data)

                    return self.getResponse(item)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse(nil, 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse(nil, 500, "Error, can't get tours by category"))
        }
    }

    func sendTourOrder(id: Int, name: String, phone: String, comment: String) -> Observable<ServerResponse<String?>> {
        guard let url = URL(string: NetworkVariables.SEND_REQUEST_TOUR_URL) else {
            return Observable.just(getResponse(nil, 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url, params: "tourId=\(id)&name=\(name)&phone=\(phone)&comment=\(comment)")
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
//                    let item = try JSONDecoder().decode(String.self, from: data)
                    return self.getResponse(String(data: data, encoding: .utf8))

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse(nil, 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse(nil, 500, "Error, can't get tours by category"))
        }
    }

    func getInfoCategories(parentId: Int) -> Observable<ServerResponse<[InfoCategory]>> {
        guard let url = URL(string: NetworkVariables.getInfoCategories(parentId: parentId)) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([InfoCategory].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of info's categories: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get info's categories"))
        }
    }

    func getInfosByCategory(id: Int) -> Observable<ServerResponse<[InfoItem]>> {
        guard let url = URL(string: NetworkVariables.getInfosURLByCategory(id: id)) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([InfoItem].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of infos by category: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get infos by category"))
        }
    }

    func getInfosByInfo(id: Int) -> Observable<ServerResponse<InfoItem?>> {
        guard let url = URL(string: NetworkVariables.getInfoURLByInfo(id: id)) else {
            return Observable.just(getResponse(nil, 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let item = try JSONDecoder().decode(InfoItem.self, from: data)

                    return self.getResponse(item)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse(nil, 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse(nil, 500, "Error, can't get infos by category"))
        }
    }

    func getTopAdsById(_ id: Int) -> Observable<ServerResponse<[TopAdItem]>> {
        guard let url = URL(string: NetworkVariables.getTopAdsURLByIdy(id)) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([TopAdItem].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of ads by id \(id): \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get ads by id: \(id)"))
        }
    }


    func getDistricts() -> Observable<ServerResponse<[District]>> {
        guard let url = URL(string: NetworkVariables.DISTRICTS_URL) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([District].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of districts: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get any districts"))
        }
    }

    func getPointCategories() -> Observable<ServerResponse<[PointCategory]>> {
        guard let url = URL(string: NetworkVariables.POINT_CATEGORIES_URL) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([PointCategory].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of point's categories: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get any point's categories"))
        }
    }

    func getPointsByData(categoryId: Int, districtId: Int) -> Observable<ServerResponse<[PointItemShort]>> {
        guard let url = URL(string: NetworkVariables.getPointsURL(categoryId: categoryId, districtId: districtId, page: 1)) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([PointItemShort].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of points: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get any points"))
        }
    }

    func getPointByPoint(id: Int) -> Observable<ServerResponse<PointItem?>> {
        guard let url = URL(string: NetworkVariables.getPointUrlByPoint(id: id)) else {
            return Observable.just(getResponse(nil, 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let item = try JSONDecoder().decode(PointItem?.self, from: data)
                    return self.getResponse(item)
                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse(nil, 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse(nil, 500, "Error, can't get point"))
        }
    }


    func getMapPointsByData(categories: [Int] = [], districts: [Int] = [], query: String? = nil) -> Observable<ServerResponse<[PointItemShort]>> {
        guard let url = URL(string: NetworkVariables.MAP_POiNTS_URL) else {
            return Observable.just(getResponse([], 500, "Wrong API url"))
        }

        do {
            var params = "d=0"

            if let query = query, query.count > 0 {
                params += "&query=\(query)"
            }

            if (categories.count > 0) {
                categories.forEach { id in
                    params += "&categories=\(id)"
                }
            }

            if (districts.count > 0) {
                districts.forEach { id in
                    params += "&districts=\(id)"
                }
            }

            let request = try getPostRequest(url: url, params: params)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let items = try JSONDecoder().decode([PointItemShort].self, from: data)

                    let sortedItems = items.sorted {
                        $0.sortOrder < $1.sortOrder
                    }
                    print("Count of points: \(items.count)")

                    return self.getResponse(sortedItems)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse([], 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse([], 500, "Error, can't get any points"))
        }
    }


    func getFilterData() -> Observable<ServerResponse<FilterData?>> {
        guard let url = URL(string: NetworkVariables.FILTER_SETTINGS_URL) else {
            return Observable.just(getResponse(nil, 500, "Wrong API url"))
        }

        do {
            let request = try getPostRequest(url: url)
            return URLSession.shared.rx.data(request: request).retry(3).map { data in
                do {
                    let filter = try JSONDecoder().decode(FilterData.self, from: data)
                    return self.getResponse(filter)

                } catch let jsonError {
                    CustomLogger.instance.reportError(error: jsonError)
                    return self.getResponse(nil, 500, "Error parse JSON")
                }
            }
        } catch let error {
            CustomLogger.instance.reportError(error: error)
            return Observable.just(getResponse(nil, 500, "Error, can't get filter data"))
        }
    }

    private func getPostRequest(url: URL, params: String? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)

        if let params = params {
            let escapedString = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            request.httpBody = escapedString.data(using: .utf8)
        }

        request.httpMethod = "POST"
        return request
    }

    private func getResponse<Type>(_ data: Type, _ status: Int = 200, _ msg: String? = nil) -> ServerResponse<Type> {
        var response = ServerResponse<Type>()
        response.status = status
        response.message = msg
        response.successful = status == 200
        response.data = data
        return response
    }
}