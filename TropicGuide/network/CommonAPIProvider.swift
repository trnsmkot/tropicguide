//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommonAPIProvider {

    func getCategories() -> Observable<ServerResponse<[TourCategory]>> {
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