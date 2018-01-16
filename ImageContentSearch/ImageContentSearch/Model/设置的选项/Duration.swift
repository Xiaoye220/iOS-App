//
//  Duration.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/15.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

// 运行持续时间
enum Duration: TimeInterval {
    case _20minutes = 1200
    case _30minutes = 1800
    case _1hours = 3600
    case _3hours = 10800
}

extension Duration {
    var text: String {
        switch self {
        case ._20minutes:
            return "20分钟"
        case ._30minutes:
            return "30分钟"
        case ._1hours:
            return "1小时"
        case ._3hours:
            return "3小时"
        }
    }
}

extension Duration: SettingType {
    
    typealias TableViewCell = CheckCell
    
    var title: String {
        return self.text
    }
    
    var cellIdentifier: String {
        return "checkCell"
    }
}
