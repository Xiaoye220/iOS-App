//
//  Log.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 17/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

func printLog<T>(_ content: T, file: String = #file, method: String = #function,line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)] - \(method) : \n-- \(content)\n")
    #endif
}
