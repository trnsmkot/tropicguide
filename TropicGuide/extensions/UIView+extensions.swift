//
//  UIView+extensions.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 25/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(),
                                                      metrics: nil, views: viewsDictionary))
    }
}


