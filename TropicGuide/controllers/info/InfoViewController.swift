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

class InfoViewController: BaseTableViewController<PointTableViewCell> {

    private let tableViewCellIdentifier = "infoTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = BehaviorRelay<[InfoItem]>(value: [])

    var infoCategory: InfoCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = infoCategory?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = infoCategory?.id, let allCatId = infoCategory?.allCatId {
            InfoViewModal.shared.getInfosByCategory(id: allCatId > 0 ? allCatId : id)?
                    .subscribe(onNext: { response in
                        if response.successful, let data = response.data  {
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
    }

    private func setupViews() {

        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? PointTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    var point = PointItemShort()
                    point.name = item.desc?.name
                    point.cover = item.cover
                    tourCell.setData(item: point)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(InfoItem.self)
                .subscribe { item in
                    if let info = item.element {
                        self.navigator?.openContentInfoViewController(info)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return 3
    }
}
