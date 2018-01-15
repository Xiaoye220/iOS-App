//
//  UIColor+Extension.swift
//  EmptyDataSet-Swift
//
//  Created by YZF on 29/6/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 根据 16进制 颜色代码初始化颜色
    ///
    /// - Parameters:
    ///   - hexColor: 颜色代码
    convenience init?(hexColor: String) {
        
        guard hexColor.characters.count == 6 else {
            return nil
        }
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        let hex = hexColor as NSString
        Scanner(string: hex.substring(with: NSRange(location: 0, length: 2))).scanHexInt32(&red)
        Scanner(string: hex.substring(with: NSRange(location: 2, length: 2))).scanHexInt32(&green)
        Scanner(string: hex.substring(with: NSRange(location: 4, length: 2))).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    convenience init?(rgb: (red: CGFloat, green: CGFloat, blue: CGFloat)) {
        self.init(red: rgb.red/255.0, green: rgb.green/255.0, blue: rgb.blue/255.0, alpha: 1)
    }
}
