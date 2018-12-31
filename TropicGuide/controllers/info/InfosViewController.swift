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

class InfosViewController: BaseViewController {

    private let tableView = UITableView()
    private let tableViewCellIdentifier = "infoCategoryTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Справочник"

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
    }

    private func setupViews() {

    }

    override func initBackButton() {
    }

}
