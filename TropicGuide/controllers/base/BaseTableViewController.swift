//
//  BaseTableViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

protocol BaseTableProtocol {
    func getTableViewCellIdentifier() -> String
    func getRowHeight() -> CGFloat?
    func needTopAdController() -> Int?
}

class BaseTableViewController<CellClass: UITableViewCell>: BaseViewController, BaseTableProtocol {

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseTable()
    }

    private func setupBaseTable() {
        view.backgroundColor = .mainBgGray

        view.subviews.forEach { view in
            view.removeFromSuperview()
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CellClass.self, forCellReuseIdentifier: getTableViewCellIdentifier())
        tableView.separatorStyle = .none
        if let rowHeight = getRowHeight() {
            tableView.rowHeight = rowHeight
        }
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainBgGray

        view.addSubview(tableView)

        if let id = needTopAdController() {
            let height = (view.frame.width - 20) / 16 * 9 + 20
            let headerView = UIView(frame: CGRect(x: -0, y: 0, width: view.frame.width - 20, height: height))
            tableView.tableHeaderView = headerView

            let topAdVC = TopAdViewController()
            topAdVC.navigator = self.navigator
            topAdVC.topAdsId = id
            addChild(topAdVC)
            headerView.addSubview(topAdVC.view)
            topAdVC.didMove(toParent: self)

            topAdVC.view.translatesAutoresizingMaskIntoConstraints = false


            headerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topAdVC.view)
            headerView.addConstraintsWithFormat(format: "V:|[v0]|", views: topAdVC.view)
        }

        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        }
//        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
    }

    func getRowHeight() -> CGFloat? {
        return (view.bounds.size.width - 20) / 16 * 9
    }

    func getTableViewCellIdentifier() -> String {
        fatalError("getTableViewCellIdentifier() has not been implemented")
    }

    func needTopAdController() -> Int? {
        return nil
    }
}