//
//  UserNotificationsUtils.swift
//  QuestionAnswerer
//
//  Created by 叶增峰 on 2018/1/13.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UserNotifications

class MyUserNotifications {
    static func notification(title: String, body: String, subtitle: String, userInfo: [AnyHashable: Any]) {
        //设置推送内容
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.subtitle = subtitle
        content.userInfo = userInfo
        //设置category标识符
        content.categoryIdentifier = "myCategory"
        //设置通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        //设置请求标识符
        let requestIdentifier = "com.yzf.QuestionAnswerer"
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
    }
}
