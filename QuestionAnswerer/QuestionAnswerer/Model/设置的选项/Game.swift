//
//  Game.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

// 游戏类型
enum Game: String {
    case cddh = "冲顶大会"
    case zscr = "芝士超人"
    case xgsp = "西瓜视频 百万英雄"
    case xmzb = "熊猫直播 一智千金"
    case other = "其他"
}

extension Game {
    
    /// 获取截屏中 问题和答案的 Rect
    /// 不知道他们布局的具体策略，只能量一量后按百分比截取了
    var questionRect: CGRect? {
        switch self {
        case .cddh:
            return CGRect(minX: 4, maxX: 96, totalX: 100, minY: 20, maxY: 64, totalY: 100)
        case .zscr:
            return CGRect(minX: 0, maxX: 100, totalX: 100, minY: 13, maxY: 55, totalY: 100)
        case .xgsp:
            return CGRect(minX: 4, maxX: 96, totalX: 100, minY: 15, maxY: 62, totalY: 100)
        case .xmzb:
            return CGRect(minX: 4, maxX: 96, totalX: 100, minY: 22, maxY: 56, totalY: 100)
        default:
            return nil
        }
    }
}

extension Game: SettingType {
    
    typealias TableViewCell = CheckCell
    
    var title: String {
        return self.rawValue
    }
    
    var cellIdentifier: String {
        return "checkCell"
    }
}
