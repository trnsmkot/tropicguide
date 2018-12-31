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

class InfoViewController: BaseTableViewController<InfoTableViewCell> {

    private let tableViewCellIdentifier = "infoTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[InfoItem]>([])

    var infoCategory: InfoCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = infoCategory?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = infoCategory?.id {
            InfoViewModal.shared.getInfosByCategory(id: id)?
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
    }

    private func setupViews() {

        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? InfoTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(item: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(InfoItem.self)
                .subscribe { item in
                    if let info = item.element {
                        self.navigator?.openContentInfoViewController(info)
                    }
                }.disposed(by: disposeBag)
    }

    override func getRowHeight() -> CGFloat {
        return 60
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }
}
