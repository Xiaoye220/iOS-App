//
//  Setting.swift
//  QuestionAnswerer
//
//  Created by 叶增峰 on 2018/1/13.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

/// 获取、保存设置中的选项
class MySetting {
    
    struct Default {
        static let game = Game.cddh
        static let questionRect = Game.cddh.questionRect!
        static let duration = Duration._20minutes
        static let searchMode = SearchMode.questionOnly
    }
    
    
    static var game: Game {
        get {
            if let value = MyUserDefaults.value(forKey: .game) as? String, let game = Game(rawValue: value) { return game }
            else { return MySetting.Default.game }
        }
        set {
            MyUserDefaults.setValue(newValue.rawValue, forKey: .game)
        }
    }
    
    
    static var questionRect: CGRect {
        get {
            if let rect = MySetting.game.questionRect {
                return rect
            } else if let x = MyUserDefaults.value(forKey: .rectX) as? CGFloat,
                let y = MyUserDefaults.value(forKey: .rectY) as? CGFloat,
                let width = MyUserDefaults.value(forKey: .rectWidth) as? CGFloat,
                let height = MyUserDefaults.value(forKey: .rectHeight) as? CGFloat {
                return CGRect(x: x, y: y, width: width, height: height)
            } else {
                return MySetting.Default.questionRect
            }
        }
        set {
            MyUserDefaults.setValue(newValue.origin.x, forKey: .rectX)
            MyUserDefaults.setValue(newValue.origin.y, forKey: .rectY)
            MyUserDefaults.setValue(newValue.size.width, forKey: .rectWidth)
            MyUserDefaults.setValue(newValue.size.height, forKey: .rectHeight)
        }
    }
    
    static var duration: Duration {
        get {
            if let value = MyUserDefaults.value(forKey: .duration) as? TimeInterval, let duration = Duration(rawValue: value) { return duration }
            else { return MySetting.Default.duration }
        }
        set {
            MyUserDefaults.setValue(newValue.rawValue, forKey: .duration)
        }
    }
    
    static var searchMode: SearchMode {
        get {
            if let value = MyUserDefaults.value(forKey: .searchMode) as? String, let searchMode = SearchMode(rawValue: value) { return searchMode }
            else { return MySetting.Default.searchMode }
        }
        set {
            MyUserDefaults.setValue(newValue.rawValue, forKey: .searchMode)
        }
    }
}
