//
//  AppDelegate.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var timer: Timer!
    
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    
    var rootController: RootViewController!
    
    let viewModel = SettingViewModel()
    
    var i = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 让音乐可以在后台运行
        // 在后台播放无声的 mp3 可以保证 app 在后台也可以一直运行
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            // 设置 option 为 mixWithOthers，否则打开其他带音频播放的app，本 app 的 avplayer 会停止播放，就无法保持后台一直运行了
            try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print(error)
        }
        
        //请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if !accepted {
                print("用户不允许消息通知。")
            }
        }
        
        //初始化播放器
        let filePath = Bundle.main.path(forResource: "clean", ofType: "mp3")!
        let url = URL(fileURLWithPath: filePath)
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem!)
        player.volume = 0
        
        let nvController = window?.rootViewController as! UINavigationController
        rootController = nvController.topViewController as! RootViewController
        rootController.viewModel = viewModel
        
        // RxSwift，后台播放音乐保持 app 运行
        RxConfiguration()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    func RxConfiguration() {
        viewModel.isPlaying.asDriver()
            .drive(onNext: { [weak self] isPlaying in
                guard let `self` = self else { return }
                if isPlaying {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                        self.player.seek(to: kCMTimeZero)
//                        self.i = self.i + 1
//                        print(self.i)
                    }
                    self.player.play()
                } else {
                    self.timer?.invalidate()
                    self.player.pause()
                    self.player.seek(to: kCMTimeZero)
                }
            })
            .disposed(by: disposeBag)
    }
}




