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

class InfosViewController: BaseTableViewController<InfoCategoryTableViewCell> {

    private let tableViewCellIdentifier = "infoCategoryTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[InfoCategory]>([])

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Справочник"

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        InfoViewModal.shared.getInfoCategories()?
                .subscribe(onNext: { response in
                    if response.successful {
                        self.dataSource.value = response.data ?? []
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
                    guard let tourCell = cell as? InfoCategoryTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(category: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(InfoCategory.self)
                .subscribe { item in
                    if let category = item.element {
                        self.navigator?.openInfosViewControllerByCategory(category)
                    }
                }.disposed(by: disposeBag)
    }

    override func initBackButton() {
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
