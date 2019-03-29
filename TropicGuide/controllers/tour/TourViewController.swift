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

class TourViewController: BaseTableViewController<TourTableViewCell>  {

    private let tableViewCellIdentifier = "tourTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[TourItem]>([])
    var tourCategory: TourCategory?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = tourCategory?.ruName ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        TourViewModal.shared.getToursByCategory(id: tourCategory?.id)?
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
                    guard let tourCell = cell as? TourTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(tour: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(TourItem.self)
                .subscribe { item in
                    if let tour = item.element {
                        self.navigator?.openTourContentViewController(tour)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return nil
    }
}