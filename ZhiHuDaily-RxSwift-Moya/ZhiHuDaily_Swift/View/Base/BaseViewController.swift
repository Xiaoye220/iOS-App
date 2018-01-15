//
//  BaseViewController.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 18/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var navigationSetting: NavigationSetting!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationSetting = NavigationSetting(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
