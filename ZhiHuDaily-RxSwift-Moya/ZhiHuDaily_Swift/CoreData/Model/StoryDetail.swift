//
//  StoryDetail.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 27/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import HandyJSON

struct StoryDetail: HandyJSON {
    var body: String!
    var css: [String] = []
    var ga_prefix: String!
    var id: Int!
    var image: String!
    var image_source: String!
    var images: [String] = []
    var js: [String] = []
    var section: [String: Any] = [:]
    var share_url: String!
    var title: String!
    var type: Int!
}
