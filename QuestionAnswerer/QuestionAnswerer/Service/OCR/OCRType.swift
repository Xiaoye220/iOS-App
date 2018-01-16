//
//  OCRType.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

protocol OCRType {
    func OCR(with image: UIImage, completion: @escaping (String?) -> Void)
}
