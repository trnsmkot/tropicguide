//
//  DistrictsViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DistrictsViewController: BaseTableViewController<DistrictTableViewCell> {

    private let tableViewCellIdentifier = "districtsTableViewCellIdentifier"
    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[District]>([])

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

//        view.backgroundColor = .red

        initSpinner(spinner: spinner, offset: 200)
        spinner.start()

        PointViewModal.shared.getDistricts()?
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

    func setupViews() {
        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? DistrictTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(district: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(District.self)
                .subscribe { item in
                    if let district = item.element {
                        self.navigator?.openPointCategoriesViewControllerByCategory(district)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return 0
    }
}
