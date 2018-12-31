//
// Created by Vladislav Kasatkin on 2018-12-25.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black

//        let backItem = UIBarButtonItem()
//        backItem.title = "Назад"
//        navigationItem.backBarButtonItem = backItem
        initBackButton()

        if let navigationController = self.navigationController {
            navigator = Navigator(navigationController)
        }
    }

    func initBackButton() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(onBackButtonClicked))
    }

    @objc func onBackButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}