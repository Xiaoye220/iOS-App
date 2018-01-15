//
//  String+Extension.swift
//  EmptyDataSet-Swift
//
//  Created by YZF on 29/6/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

extension String {
    
    
    /// 利用下标截取字符串
    /// example: 字符串 str = "abcdefg", str[0,1] = "ab", str[1, 3] = "bcd"
    ///
    /// - Parameters:
    ///   - from: 开始截取的位置
    ///   - to: 结束截取的位置，包含这个位置的字符
    subscript(_ from: Int, _ to: Int) -> String {
        guard to >= from else {
            return String()
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        
        return String(self[startIndex...endIndex])
    }
    
}
