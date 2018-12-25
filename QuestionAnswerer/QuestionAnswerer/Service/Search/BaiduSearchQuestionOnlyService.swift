//
//  SearchQuestionOnlyService.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation

/// 通过百度直接查找题目
class BaiduSearchQuestionOnlyService: BaiduSearchType {
    
    typealias Result = String
    
    var question = String()
    var answer_1 = String()
    var answer_2 = String()
    var answer_3 = String()
    
    var key: String {
        get { return question}
        set {}
    }
    
    var content: (question: String, answers: [String]) = (String(), []) {
        didSet {
            self.question = content.question
            answer_1 = String()
            answer_2 = String()
            answer_3 = String()
            let count = content.answers.count
            if count > 0 { answer_1 = content.answers[0] }
            if count > 1 { answer_2 = content.answers[1] }
            if count > 2 { answer_3 = content.answers[2] }
        }
    }
    
    init() { }
    
    func search(_ completion: @escaping (Result?) -> Void) {
        guard let request = request else {
            completion(nil)
            return
        }
        //使用URLSession发起请求
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let text = String.init(data: data!, encoding: .utf8)!
                    let result = self.parserText(text)
                    completion(result)
                }
            }
            } as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
    
    /// 解析搜索到的结果，简单的统计了每个答案在结果中出现的次数，排序
    func parserText(_ text: String) -> Result {
        var finalText = text
        var com: [String] = []
        
        if finalText.contains("<div id=\"rs\">") {
            com = text.components(start: "<div id=\"content_left\">", end: "<div id=\"rs\">")
        } else if finalText.contains("<div id=\"page\" >") {
            com = text.components(start: "<div id=\"content_left\">", end: "<div id=\"page\" >")
        }
        if com.count > 0 {
            let subCom = com[0].components(start: ">", end: "<")
            finalText = subCom.reduce(String()) { return $0 + $1 }
        }
        
        var count_1 = finalText.components(separatedBy: answer_1).count - 1
        var count_2 = finalText.components(separatedBy: answer_2).count - 1
        var count_3 = finalText.components(separatedBy: answer_3).count - 1
        
        
        if count_1 == 0 && count_2 == 0 && count_3 == 0 {
            if !answer_1.isEmpty {
                count_1 = (finalText.components(separatedBy: CharacterSet(charactersIn: answer_1)).count - 1) / answer_1.count
            }
            if !answer_2.isEmpty {
                count_2 = (finalText.components(separatedBy: CharacterSet(charactersIn: answer_2)).count - 1) / answer_2.count
            }
            if !answer_3.isEmpty {
                count_3 = (finalText.components(separatedBy: CharacterSet(charactersIn: answer_3)).count - 1) / answer_3.count
            }
        }
        
        var result = [(answer_1, count_1),
                      (answer_2, count_2),
                      (answer_3, count_3)]
        
        result.sort { $0.1 > $1.1 }
        
        return "\(result[0].0) - \(result[0].1) , \(result[1].0) - \(result[1].1) , \(result[2].0) - \(result[2].1)"
    }
}
