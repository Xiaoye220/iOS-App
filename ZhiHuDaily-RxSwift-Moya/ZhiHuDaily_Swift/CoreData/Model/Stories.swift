//
//  Stories.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 12/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import HandyJSON

struct Stories: HandyJSON {
    var date: String!
    var stories: [Story] = []
    var top_stories: [TopStory] = []
}
