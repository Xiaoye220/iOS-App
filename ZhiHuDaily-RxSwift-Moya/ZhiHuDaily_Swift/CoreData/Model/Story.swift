//
//  Story.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 11/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import HandyJSON

struct Story: HandyJSON {
    var ga_prefix: String!
    var id: Int!
    var images: [String] = []
    var title: String!
    var type: Int!
}
