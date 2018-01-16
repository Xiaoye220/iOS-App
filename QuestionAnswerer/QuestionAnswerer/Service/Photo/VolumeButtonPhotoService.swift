//
//  VolumeButtonPhotoService.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/15.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import AVFoundation


/// 按音量键获取图片，但是音量键按完后会弹出音量变化的视图挡住屏幕，只能放弃
class VolumeButtonPhotoService: PhotoType {
    
    var delegate: PhotoDelegate!
    
    func beginObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange(_:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func endObserve() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func volumeDidChange(_ notification: NSNotification) {
        print(AVAudioSession.sharedInstance().outputVolume)
    }
}
