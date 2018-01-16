//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo
        
        self.label?.text = content.body

        if let question = userInfo["question"] as? String, let answer = userInfo["answer"] as? String {
            self.label?.text = content.body + "\n\n" + question + "\n" + answer
        }
    }

}
