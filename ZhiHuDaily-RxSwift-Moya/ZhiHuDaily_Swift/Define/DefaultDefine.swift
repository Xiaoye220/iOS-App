//
//  DefaultDefine.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 20/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }
var screenHeight: CGFloat { return UIScreen.main.bounds.height }

let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)

let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let device = UIDevice.current.userInterfaceIdiom

let statusBarHeight = UIApplication.shared.statusBarFrame.height
let navigationBarHeight: CGFloat = 44
