//
//  FilterViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    private static var filter: FilterData?
    var currentFilterData: BehaviorRelay<PointFilter>?

    private var localPintFilterData = PointFilter()
    private var pointFilterData = PointFilter()

    private let spinner = Spinner()

    private let tableCellIdentifier = "filterTableViewCellIdentifier"
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Фильтр"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearFilterData))

        setupViews()
        initSpinner(spinner: spinner)

        if (FilterViewController.filter == nil) {
            spinner.start()
            FilterViewModal.shared.getFilterData()?
                    .subscribe(onNext: { response in
                        if response.successful {
                            FilterViewController.filter = response.data ?? nil
                            self.tableView.reloadData()
                            self.spinner.end()
                        } else {
                            // Вывести ошибку получения данных ?
                        }
                    }, onError: { error in
                        self.spinner.end()
                        CustomLogger.instance.reportError(error: error)
                        // Вывести ошибку получения данных ?
                    }).disposed(by: disposeBag)
        }

        if let currentFilterData = currentFilterData?.value {
            localPintFilterData.categories = currentFilterData.categories
            localPintFilterData.districts = currentFilterData.districts
            tableView.reloadData()
        }
    }

    func setupViews() {
        view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainBgGray

        view.addSubview(tableView)

        let applyButton = UIButton()
        applyButton.setTitle("Применить", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .simpleBlue
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)

        view.addSubview(applyButton)


        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

            applyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            applyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        } else {
            view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
            view.addConstraintsWithFormat(format: "V:[v0(40)]-10-|", views: applyButton)
        }

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: applyButton)
    }

    @objc func clearFilterData(sender: UIBarButtonItem) {
        localPintFilterData.districts = []
        localPintFilterData.categories = []
        tableView.reloadData()
    }

    @objc func applyFilter() {
        pointFilterData.categories = localPintFilterData.categories
        pointFilterData.districts = localPintFilterData.districts
        currentFilterData?.accept(pointFilterData)
        navigationController?.popViewController(animated: true)
    }

}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier) as? FilterTableViewCell {
            switch indexPath.section {
            case 0:
                if let item = FilterViewController.filter?.categories[indexPath.item] {
                    cell.setData(data: item, filter: localPintFilterData, section: 0)
                }
            case 1:
                if let item = FilterViewController.filter?.districts[indexPath.item] {
                    cell.setData(data: item, filter: localPintFilterData, section: 1)
                }
            default: break
            }

            return cell
        }

        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return FilterViewController.filter?.categories.count ?? 0
        case 1: return FilterViewController.filter?.districts.count ?? 0
        default: return 0
        }
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0: return "Категории"
        case 1: return "Районы"
        default: return nil
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}