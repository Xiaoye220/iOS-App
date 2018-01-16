//
//  Icon.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import YFIconFont


enum Icon: String {
    case setting = "\u{e632}"
    case imagePlaceHolder = "\u{e627}"
    case check  = "\u{e631}"
    case play = "\u{e624}"
    case pause = "\u{e629}"
}

extension Icon: IconFontType {
    
    static var fontName: String {
        return "iconfont"
    }
    
    static var fontFilePath: String?  = Bundle.main.path(forResource: "iconfont", ofType: "ttf")
    
    var unicode: String {
        return self.rawValue
    }
}
