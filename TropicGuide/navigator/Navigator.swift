//
//  Navigator.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

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
}
