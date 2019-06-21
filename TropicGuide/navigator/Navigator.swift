//
//  Navigator.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FBSDKCoreKit
import FacebookCore

class Navigator {
    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func openToursViewControllerByCategory(_ category: TourCategory) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "tourCategories", "name": category.ruName ?? "empty"])

        let tourViewController = TourViewController()
        tourViewController.tourCategory = category
        navigationController.pushViewController(tourViewController, animated: true)
    }


    func openTourContentViewController(_ tour: TourItem) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "tour", "name": tour.ruDesc?.name ?? "empty"])

        let tourContentViewController = TourContentViewController()
        tourContentViewController.tourItem = tour
        navigationController.pushViewController(tourContentViewController, animated: true)
    }

    func openInfoViewControllerByCategory(_ category: InfoCategory) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "infoCategories", "name": category.name ?? "empty"])

        let infoViewController = InfoViewController()
        infoViewController.infoCategory = category
        navigationController.pushViewController(infoViewController, animated: true)
    }

    func openZoomImageViewControllerByCategory(_ url: String?) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "image"])

        let zoomImageViewController = ZoomImageViewController()
        zoomImageViewController.bigImageUrl = url
        navigationController.pushViewController(zoomImageViewController, animated: true)
    }

    func openDescViewControllerByCategory(title: String?, desc: NSAttributedString?) {
        let controller = TourDescViewController()
        controller.name = title
        controller.desc = desc
        navigationController.pushViewController(controller, animated: true)
    }

    func openInfosViewControllerByParentCategory(_ parentCategory: InfoCategory) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "infosCategories", "name": parentCategory.name ?? "empty"])

        let infosViewController = InfosViewController()
        infosViewController.parentCategory = parentCategory
        navigationController.pushViewController(infosViewController, animated: true)
    }


    func openContentInfoViewController(_ info: InfoItem) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "info", "name": info.desc?.name ?? "empty"])

        let infoViewController = InfoContentViewController()
        infoViewController.infoItem = info
        navigationController.pushViewController(infoViewController, animated: true)
    }

    func openTopAdContentController(_ ad: TopAdItem) {
        AppEvents.logEvent(.adClick, parameters: ["ad_type": "\(ad.type): \(ad.title ?? "None")"])

        switch ad.type {
        case .LINK:
            let adViewController = WebViewController()
            var tour = TourItem()
//            tour.url = ad.link
            tour.ruDesc?.name = ad.title
            tour.cover = ad.image

            adViewController.tour = tour
            navigationController.pushViewController(adViewController, animated: true)
        case .TOUR:
            let tourContentViewController = TourContentViewController()

            var tour = TourItem()
            tour.id = ad.parentId
            tour.ruDesc = TourItemDesc()
            tour.ruDesc?.name = ad.title
            tour.cover = ad.image
            tourContentViewController.tourItem = tour

            navigationController.pushViewController(tourContentViewController, animated: true)
        case .POINT:

            return
        }


    }

    func openPointContentViewController(_ point: PointItemShort) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "point", "name": point.desc?.name ?? "empty"])

        let pointContentViewController = PointContentViewController()
        pointContentViewController.pointItem = point
        navigationController.pushViewController(pointContentViewController, animated: true)
    }

//    func openPointCategoriesViewControllerByCategory(_ district: District) {
//        let pointCategoriesViewController = PointCategoriesViewController()
//        pointCategoriesViewController.district = district
//        navigationController.pushViewController(pointCategoriesViewController, animated: true)
//    }

    func openPointsViewController(category: PointCategory) {
        AppEvents.logEvent(.viewedContent, parameters: ["view": "points", "name": category.name ?? "empty"])

        let pointsViewController = PointsViewController()
        pointsViewController.category = category
        navigationController.pushViewController(pointsViewController, animated: true)
    }

    func openFilterViewController(filter: BehaviorRelay<PointFilter>) {
        let filterViewController = FilterViewController()
        filterViewController.currentFilterData = filter
        navigationController.pushViewController(filterViewController, animated: true)
    }
}
