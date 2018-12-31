//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

extension UIViewController {

    func initSpinner(spinner: Spinner) {
        spinner.commonInit(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        spinner.isHidden = true
        self.view.addSubview(spinner)
    }
}