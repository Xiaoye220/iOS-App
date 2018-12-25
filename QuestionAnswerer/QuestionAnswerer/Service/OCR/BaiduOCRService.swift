////
//  OCRService.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import SwiftyJSON


/// 百度OCR企业版，前200次免费
/// http://apistore.baidu.com/apiworks/servicedetail/969.html?hp.com
class BaiduOCRService: OCRType {
    
    // 你自己的 apikey
    let apikey = "8be1c31a4726b6b7934ca6a6f528d5ea"
    
    init() { }

    func OCR(with image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0) else {
            completion(nil)
            return
        }
        
        //将图片转为base64编码
        let base64 = imageData.base64EncodedString(options: .endLineWithLineFeed)
        //继续将base64字符串urlencode一下，确保只有数字和字母
        let imageString = base64.addingPercentEncoding(withAllowedCharacters:
            .alphanumerics)
        request(imageString: imageString!, completion: completion)
    }
    
    //请求API接口
    func  request(imageString: String, completion: @escaping (String?) -> Void) {
        //接口地址（使用http：//也可以，记得再info.plist里做相关的配置）
        let httpUrl = "https://apis.baidu.com/idl_baidu/baiduocrpay/idlocrpaid"
        //参数拼接
        let httpArg = "fromdevice=iPhone&clientip=10.10.10.0&detecttype=LocateRecognize" +
            "&languagetype=CHN_ENG&imagetype=1&image=" + imageString
        
        //创建请求对象
        var request = URLRequest(url: URL(string: httpUrl)!)
        request.timeoutInterval = 6
        request.httpMethod = "POST"
        // apikey 自己填写
        request.addValue(apikey, forHTTPHeaderField: "apikey")
        request.addValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        //设置请求内容
        request.httpBody = httpArg.data(using: .utf8)
        
        //使用URLSession发起请求
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                                completion(nil)
                                            } else if let data = data {
                                                //解析数据并显示结果
                                                var result = ""
                                                let json = try! JSON(data: data)
                                                //循环每个区域识别出来的内容
                                                for subJson in json["retData"] {
                                                    let stringValue = subJson.1["word"].stringValue
                                                    result.append("\(stringValue)\n") //识别的内容
                                                }
                                                completion(result)
                                            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
}
