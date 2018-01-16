//
//  String+Extension.swift
//  ImageContentSearch
//
//  Created by 叶增峰 on 2018/1/14.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    func components(start: String, end: String) -> [String] {
        var result: [String] = []
        let com1 = self.components(separatedBy: start)
        for com in com1 {
            let com2 = com.components(separatedBy: end)
            if com2.count > 1 {
                result.append(com2[0])
            }
        }
        
        return result
    }
}
