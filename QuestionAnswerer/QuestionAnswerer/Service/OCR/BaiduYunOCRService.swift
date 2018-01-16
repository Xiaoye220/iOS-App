//
//  BaiduYunOCRService.swift
//  QuestionAnswerer
//
//  Created by 叶增峰 on 2018/1/13.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


/// 百度云文字识别，每天有定量免费
/// https://cloud.baidu.com/product/ocr
class BaiduYunOCRService: OCRType {
    
    // 你自己的 apiKey 和 secretKey
    let apiKey = "..."
    let secretKey = "..."
    
    init() {
        AipOcrService.shard().auth(withAK: apiKey, andSK: secretKey)
        
        // 第一次请求会 request token 需要很长时间，提前做了。
        self.OCR(with: UIImage()) { _ in }
    }
    
    
    /// 百度云普通文字识别，每天 500 次免费
    func OCR(with image: UIImage, completion: @escaping (String?) -> Void) {
        AipOcrService.shard().detectTextBasic(from: image, withOptions: nil, successHandler: { data in
            if let data = data {
                var result = ""
                let json = JSON(data)
                //循环每个区域识别出来的内容
                for subJson in json["words_result"] {
                    let stringValue = subJson.1["words"].stringValue
                    result.append("\(stringValue)\n") //识别的内容
                }
                completion(result)
            } else {
                completion(nil)
            }
        }) { error in
            print("BaiduYunOCR failed \n \(error.debugDescription)")
            completion(nil)
        }
    }
    
    /// 百度云精确文字识别，每天 50 次免费
    func OCRAccurate(with image: UIImage, completion: @escaping (String?) -> Void) {
        AipOcrService.shard().detectTextAccurateBasic(from: image, withOptions: nil, successHandler: { data in
            if let data = data {
                var result = ""
                let json = JSON(data)
                //循环每个区域识别出来的内容
                for subJson in json["words_result"] {
                    let stringValue = subJson.1["words"].stringValue
                    result.append("\(stringValue)\n") //识别的内容
                }
                completion(result)
            } else {
                completion(nil)
            }
        }) { error in
            print("BaiduYunOCR failed \n \(error.debugDescription)")
            completion(nil)
        }
    }
    
    
    
}
