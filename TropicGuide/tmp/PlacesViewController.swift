//
//  PlacesViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class PlacesViewController: BaseViewController {

    private let segmentControl = UISegmentedControl(items: ["Районы", "Категории"])
    private let scrollView = UIScrollView()
    private let contentScrollView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView

        setupViews()
        setupControllers()
    }

    func setupControllers() {
        let districtsVC = DistrictsViewController()
        districtsVC.navigator = self.navigator
        districtsVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(districtsVC)
        contentScrollView.addSubview(districtsVC.view)
        districtsVC.didMove(toParent: self)

        contentScrollView.addConstraintsWithFormat(format: "H:|[v0]-\(view.frame.width)-|", views: districtsVC.view)
        contentScrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: districtsVC.view)


        let pointCategoriesVC = PointCategoriesViewController()
        pointCategoriesVC.navigator = self.navigator
        pointCategoriesVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(pointCategoriesVC)
        contentScrollView.addSubview(pointCategoriesVC.view)
        pointCategoriesVC.didMove(toParent: self)

        contentScrollView.addConstraintsWithFormat(format: "H:|-\(view.frame.width)-[v0]|", views: pointCategoriesVC.view)
        contentScrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: pointCategoriesVC.view)
    }

    func setupViews() {
        view.backgroundColor = .mainBgGray

        view.subviews.forEach { view in
            view.removeFromSuperview()
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .red
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        if #available(iOS 11.0, *) {
            scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.safeAreaLayoutGuide.layoutFrame.height - 220)
        } else {
            scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height - 220)
        }

        scrollView.delegate = self
        view.addSubview(scrollView)


        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = .darkBlue
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControl)

        segmentControl.addTarget(self, action: #selector(scrollCollectionView), for: .valueChanged)

        if #available(iOS 11.0, *) {
            segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            view.addConstraintsWithFormat(format: "V:|-74-[v0(30)]", views: segmentControl)
            view.addConstraintsWithFormat(format: "V:|-54-[v0]|", views: scrollView)
        }

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: segmentControl)


        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentScrollView.backgroundColor = .yellow
        scrollView.addSubview(contentScrollView)

        scrollView.addConstraintsWithFormat(format: "H:|[v0(\(view.frame.width * 2))]", views: contentScrollView)
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            print(topPadding, bottomPadding)
            let offset = 142 + topPadding + bottomPadding
            scrollView.addConstraintsWithFormat(format: "V:|[v0(\(view.frame.size.height - offset))]", views: contentScrollView)
        } else {
            scrollView.addConstraintsWithFormat(format: "V:|[v0(\(view.frame.size.height - 166))]", views: contentScrollView)
        }

    }

    @objc func scrollCollectionView() {
        let index = CGFloat(segmentControl.selectedSegmentIndex)
        scrollView.scrollRectToVisible(CGRect(x: index * view.frame.width, y: 0, width: view.frame.width, height: view.frame.height - 220), animated: true)
    }

    override func initBackButton() {
    }
}

extension PlacesViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == 0) {
            segmentControl.selectedSegmentIndex = 0
        }
        if (scrollView.contentOffset.x == view.frame.width) {
            segmentControl.selectedSegmentIndex = 1
        }
    }
}
