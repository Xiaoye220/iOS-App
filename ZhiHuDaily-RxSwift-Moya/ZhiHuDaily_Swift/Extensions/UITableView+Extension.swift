//
//  UITableView+Extension.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 25/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit

extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView()
    }
}
