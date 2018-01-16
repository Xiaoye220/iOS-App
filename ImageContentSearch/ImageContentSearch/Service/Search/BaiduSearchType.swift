//
//  SearchType.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

protocol BaiduSearchType {
    associatedtype Result
    
    var key: String { get set }
    
    var urlString: String { get }
    
    var request: URLRequest? { get }
    
    func search(_ completion: @escaping (Result?) -> Void)
}

extension BaiduSearchType {
    var urlString: String {
        return "https://www.baidu.com/baidu?wd=\(key)&tn=monline_dg&ie=utf-8"
    }
    
    var request: URLRequest? {
        guard let encodingURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodingURL) else {
                return nil
        }
        
        //创建请求对象
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = "GET"
        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.addValue("text/html, application/xhtml+xml, */*", forHTTPHeaderField: "Accept")
        request.addValue("en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3", forHTTPHeaderField: "Accept-Language")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        return request
    }
}
