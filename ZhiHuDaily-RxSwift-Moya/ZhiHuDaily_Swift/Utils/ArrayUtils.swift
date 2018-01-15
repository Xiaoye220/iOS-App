//
//  ArrayUtils.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 2/11/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

class ArrayUtils {
    
    class func findPreviousElementInIdyadicArray<T>(_ array: [[T]], element: T) -> T? where T: Equatable {
        var index: (i1: Int, i2: Int) = (0, 0)
        for (i1, a1) in array.enumerated() {
            for (i2, a2) in a1.enumerated() {
                if a2 == element {
                    index = (i1, i2)
                }
            }
        }
        if index == (0, 0) {
            return nil
        } else if index.i2 == 0 {
            return array[index.i1 - 1][index.i2]
        } else {
            return array[index.i1][index.i2 - 1]
        }
    }
    
}
