//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

extension UIViewController {

    func initSpinner(spinner: Spinner, offset: CGFloat = 0) {
        spinner.commonInit(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - offset))
        spinner.isHidden = true
        self.view.addSubview(spinner)
    }

    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()

        return label.frame.height
    }
}