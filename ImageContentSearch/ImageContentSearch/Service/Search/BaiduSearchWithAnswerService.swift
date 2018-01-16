//
//  DefaultSearchService.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

/// 通过百度 以 题目 + 各答案 为关键字查找
class BaiduSearchWithAnswerService: BaiduSearchQuestionOnlyService {
    
     override var key: String {
        get { return question + " " + answer_1 + " " + answer_2 + " " + answer_3 }
        set {}
    }
}
