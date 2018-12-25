//
//  PhotoType.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol PhotoType {
    
    var delegate: PhotoDelegate! { get set }
    
    //开始获取图片
    func beginObserve()
    
    //结束获取图片
    func endObserve()
}


