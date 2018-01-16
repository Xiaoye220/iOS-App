//
//  UserDefaultsUtils.swift
//  CardWatch
//
//  Created by 叶增峰 on 11/5/17.
//  Copyright © 2017年 叶增峰. All rights reserved.
//

import Foundation
import UIKit

enum UserDefaultsKey: String {
    case game
    case rectX
    case rectY
    case rectWidth
    case rectHeight
    case duration
    case searchMode
}

class MyUserDefaults {
    
    class func value(forKey key: UserDefaultsKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    class func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
}
