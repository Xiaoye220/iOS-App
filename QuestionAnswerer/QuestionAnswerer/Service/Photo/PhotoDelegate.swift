//
//  PhotoDelegate.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoDelegate: class {
    func didTakeScreenshot(image: UIImage?)
}
