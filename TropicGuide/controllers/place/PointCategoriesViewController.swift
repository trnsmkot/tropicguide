//
//  PointCategoriesViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PointCategoriesViewController: BaseTableViewController<PointCategoryTableViewCell> {

    private let tableViewCellIdentifier = "pointCategoriesTableViewCellIdentifier"
    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = BehaviorRelay<[PointCategory]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView

        setupViews()

        initSpinner(spinner: spinner)

        spinner.start()
        PointViewModal.shared.getPointCategories()?
                .subscribe(onNext: { response in
                    if response.successful, let data = response.data {
                        self.dataSource.accept(data)
                    } else {
                        // Вывести ошибку получения данных ?
                    }
                    self.spinner.end()
                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
                    self.spinner.end()
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)
    }

    func setupViews() {
        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? PointCategoryTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(category: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(PointCategory.self)
                .subscribe { item in
                    if let category = item.element {
                        self.navigator?.openPointsViewController(category: category)
                    }
                }.disposed(by: disposeBag)
    }

    override func initBackButton() {
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func getRowHeight() -> CGFloat {
        return 60
    }

    override func needTopAdController() -> Int? {
        return 1
    }


}
