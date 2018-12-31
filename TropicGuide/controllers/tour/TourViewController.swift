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

class TourViewController: BaseViewController {

    private let tableView = UITableView()
    private let tableViewCellIdentifier = "tourTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[TourItem]>([])
    var tourCategory: TourCategory?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = tourCategory?.name ?? ""

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
        view.backgroundColor = .white

        view.subviews.forEach { view in
            view.removeFromSuperview()
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TourTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = (view.bounds.size.width - 20) / 16 * 9
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(tableView)

        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        }

        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: tableView)

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

}