//
//  BaseTabBarControllerViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class BaseTabBarControllerViewController: UITabBarController {
  
    @IBInspectable let defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
        tabBar.barTintColor = UIColor.white
        
        tabBar.tintColor = UIColor.simpleBlue
        tabBar.unselectedItemTintColor = .black
        
//        if let items = tabBar.items {
//            for item in items {
//                item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
//            }
//        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
