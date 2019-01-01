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

    let dataSource = Variable<[PointCategory]>([])

    var district: District?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let district = district {
            navigationItem.title = district.desc?.name
        }

        setupViews()

        initSpinner(spinner: spinner, offset: district == nil ? 200 : 0)
        spinner.start()

        PointViewModal.shared.getPointCategories()?
                .subscribe(onNext: { response in
                    if response.successful {
                        self.dataSource.value = response.data ?? []
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
                        self.navigator?.openPointsViewController(category: category, district: self.district)
                    }
                }.disposed(by: disposeBag)
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
