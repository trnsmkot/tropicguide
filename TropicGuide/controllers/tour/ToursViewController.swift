//
//  ToursViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToursViewController: BaseTableViewController<TourCategoryTableViewCell> {

    private let tableViewCellIdentifier = "tourCategoryTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[TourCategory]>([])

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Экскурсии"

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        TourViewModal.shared.categories
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

    override func initBackButton() {}

    private func setupViews() {
        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? TourCategoryTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(category: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(TourCategory.self)
                .subscribe { item in
                    if let category = item.element {
                        self.navigator?.openToursViewControllerByCategory(category)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }
}