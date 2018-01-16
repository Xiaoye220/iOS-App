//
//  CGRect+Extension.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/13.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {    
    
    
    /// 以左上角有原点的左边系，获取 rect，坐标自定义
    ///
    /// - Parameters:
    ///   - minX: 较小 x 坐标
    ///   - maxX: 较大 x 坐标
    ///   - totalX: x 坐标总长度
    ///   - minY: 较小 y 坐标
    ///   - maxY: 较大 y 坐标
    ///   - totalY: y 坐标总长度
    init(minX: CGFloat, maxX: CGFloat, totalX: CGFloat, minY: CGFloat, maxY: CGFloat, totalY: CGFloat) {
        let rect = UIScreen.main.bounds
        let x = rect.width * (minX / totalX)
        let y = rect.height * (minY / totalY)
        let width = rect.width * (maxX - minX) / totalX
        let height = rect.height * (maxY - minY) / totalY
        self.init(x: x, y: y, width: width, height: height)
    }
    
    
}
