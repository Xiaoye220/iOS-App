//
//  SettingType.swift
//  ImageContentSearch
//
//  Created by 叶增峰 on 2018/1/13.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

// 设置选项需要实现的协议
protocol SettingType {
    
    var title: String { get }
    var cellIdentifier: String { get }
    
    func tableView<T: UITableViewCell>(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> T
}

extension SettingType {
    func tableView<T: UITableViewCell>(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> T {
        var cell: T! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? T
        if cell == nil {
            cell = T(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell
    }
}
