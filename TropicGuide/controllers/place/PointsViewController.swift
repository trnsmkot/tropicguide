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

class PointsViewController: BaseTableViewController<PointTableViewCell> {

    private let tableViewCellIdentifier = "pointsTableViewCellIdentifier"
    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[PointItemShort]>([])

    var district: District?
    var category: PointCategory?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let category = category {
            navigationItem.title = category.name
        }

        setupViews()

        initSpinner(spinner: spinner, offset: district == nil ? 200 : 0)
        spinner.start()

        PointViewModal.shared.getPointsByData(categoryId: category?.id ?? 0, districtId: district?.id ?? 0)?
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
                    guard let pointCell = cell as? PointTableViewCell else {
                        return
                    }
                    pointCell.selectionStyle = .none
                    pointCell.setData(item: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(PointItemShort.self)
                .subscribe { item in
                    if let point = item.element {
                        self.navigator?.openPointContentViewController(point)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return 2
    }
}
