//
//  DataUtils.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 26/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

class DateUtils {
    
    // 20171024 -> 10月24日 星期X
    class func sectionHeaderDateTransform(_ dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MM月dd日 cccc"
            return dateFormatter.string(from: date)
        }
        return dateStr
    }
    
}
