//
//  ZhiHuDaily.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 11/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import Moya

enum ZhiHu {
    case image(url: String)
    case latestStories
    case beforeStories(date: String)
    case storyDetail(id: Int)
    case string(url: String)
}

extension ZhiHu: TargetType {
    var baseURL: URL {
        switch self {
        case .image(let url), .string(let url):
            return URL(string: url)!
        default:
            return URL(string: "https://news-at.zhihu.com")!
        }
    }
    
    var path: String {
        switch self {
        case .image, .string:
            return ""
        case .latestStories:
            return "/api/4/news/latest"
        case .beforeStories(let date):
            return "/api/4/news/before/\(date)"
        case .storyDetail(let id):
            return "/api/4/news/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

