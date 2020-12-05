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


        if let navigationController = self.navigationController {
            navigator = Navigator(navigationController)
        }
        initBackButton()
    }

    func initBackButton() {
        navigationItem.hidesBackButton = true
        let backImage = UIImage(named: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClicked))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onBackButtonClicked))
    }

    @objc func onBackButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}