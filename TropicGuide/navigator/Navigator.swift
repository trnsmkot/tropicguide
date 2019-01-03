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

class Navigator {
    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func openToursViewControllerByCategory(_ category: TourCategory) {
        let tourViewController = TourViewController()
        tourViewController.tourCategory = category
        navigationController.pushViewController(tourViewController, animated: true)
    }


    func openTourContentViewController(_ tour: TourItem) {
        let tourContentViewController = WebViewController()
        tourContentViewController.tour = tour
        navigationController.pushViewController(tourContentViewController, animated: true)
    }

    func openInfosViewControllerByCategory(_ category: InfoCategory) {
        let infoViewController = InfoViewController()
        infoViewController.infoCategory = category
        navigationController.pushViewController(infoViewController, animated: true)
    }

    func openContentInfoViewController(_ info: InfoItem) {
        let infoViewController = InfoContentViewController()
        infoViewController.infoItem = info
        navigationController.pushViewController(infoViewController, animated: true)
    }

    func openTopAdContentController(_ ad: TopAdItem) {
        switch ad.type {
        case .LINK:
            let adViewController = WebViewController()
            var tour = TourItem()
            tour.url = ad.link
            tour.name = ad.title
            tour.cover = ad.image

            adViewController.tour = tour
            navigationController.pushViewController(adViewController, animated: true)
        case .TOUR:
            let adViewController = WebViewController()
            var tour = TourItem()
            tour.url = ad.link
            tour.name = ad.title
            tour.cover = ad.image

            adViewController.tour = tour
            navigationController.pushViewController(adViewController, animated: true)
        case .POINT:

            return
        }


    }

    func openPointContentViewController(_ point: PointItemShort) {
        let pointContentViewController = PointContentViewController()
        pointContentViewController.pointItem = point
        navigationController.pushViewController(pointContentViewController, animated: true)
    }

    func openPointCategoriesViewControllerByCategory(_ district: District) {
        let pointCategoriesViewController = PointCategoriesViewController()
        pointCategoriesViewController.district = district
        navigationController.pushViewController(pointCategoriesViewController, animated: true)
    }

    func openPointsViewController(category: PointCategory, district: District?) {
        let pointsViewController = PointsViewController()
        pointsViewController.district = district
        pointsViewController.category = category
        navigationController.pushViewController(pointsViewController, animated: true)
    }

    func openFilterViewController(filter: BehaviorRelay<PointFilter>) {
        let filterViewController = FilterViewController()
        filterViewController.currentFilterData = filter
        navigationController.pushViewController(filterViewController, animated: true)
    }
}
