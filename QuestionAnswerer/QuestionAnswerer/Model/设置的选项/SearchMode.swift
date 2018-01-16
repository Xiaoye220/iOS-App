//
//  SearchMode.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/15.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

// 查找方式
enum SearchMode: String {
    case questionOnly = "题目搜索"
    case questionWithAnswer = "题目带答案搜索"
    case all = "两种方式同时搜索"
}


extension SearchMode: SettingType {
    
    typealias TableViewCell = CheckCell
    
    var title: String {
        return self.rawValue
    }
    
    var cellIdentifier: String {
        return "checkCell"
    }
}
