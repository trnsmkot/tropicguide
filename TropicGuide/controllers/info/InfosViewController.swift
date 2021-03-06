//
//  InfosViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InfosViewController: BaseTableViewController<PointCategoryTableViewCell> {

    private let tableViewCellIdentifier = "infoCategoryTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = BehaviorRelay<[InfoCategory]>(value: [])

    public var parentCategory: InfoCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.parentCategory?.name ?? "Handbook"

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        InfoViewModal.shared.getInfoCategories(parentId: parentCategory?.id ?? -1)?
                .subscribe(onNext: { response in
                    if response.successful, let data = response.data {
                        self.dataSource.accept(data)
                    } else {
//                        _ = self.navigationController?.popViewController(animated: true)
                        // Вывести ошибку получения данных ?
                    }

                    self.spinner.end()

                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
//                    _ = self.navigationController?.popViewController(animated: true)

                    self.spinner.end()
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)
    }

    private func setupViews() {

        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? PointCategoryTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    var pointCategory = PointCategory()
                    pointCategory.name = item.name
                    pointCategory.icon = item.icon
                    tourCell.setData(category: pointCategory)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(InfoCategory.self)
                .subscribe { item in
                    if let category = item.element {
                        if (self.parentCategory == nil && category.total > 1) {
                            self.navigator?.openInfosViewControllerByParentCategory(category)
                        } else {
                            self.navigator?.openInfoViewControllerByCategory(category)
                        }
                    }
                }.disposed(by: disposeBag)
    }

    override func initBackButton() {
        if (parentCategory != nil) {
            super.initBackButton()
        }
    }

    override func getRowHeight() -> CGFloat {
        return 60
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return 3
    }
}
