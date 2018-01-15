//
//  Config.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 11/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    struct StoryCell {
        static let placeHoldImage = UIImage(named: "imagePlaceHolder")!
    }
    
    struct TopStoryView {
        static let placeHoldImage = UIImage(named: "imagePlaceHolder")!
    }
    
    struct HomeController {
        static let topStoryViewHeight: CGFloat = 220
        static let topStoryImageViewHeight: CGFloat = 320
        static let topStoryPageCount: Int = 5
        
        static let refreshOffsetY: CGFloat = -50
        static let heightForHeaderInSection: CGFloat = 44
        static let rowHeight: CGFloat = 88
        
        static let topStoryFontSize: CGFloat = 20
        static let headerViewFontSize: CGFloat = 17
        static let cellFontSize: CGFloat = 16
        
    }
    
    struct StoryDetailController {
        static let headerViewHeight: CGFloat = 220
        static let headerImageViewHeight: CGFloat = 300
        static let cssImageHolderHeight: CGFloat = 200
        
        static let headerViewTitleFontSize: CGFloat = 20
        static let headerViewImageSourceFontSize: CGFloat = 8
        static let headerViewUpLabelFontSize: CGFloat = 15
        static let headerViewArrowRotateOffsetY: CGFloat = -60
        
        static let headerViewPlaceHoldImage = UIImage(named: "imagePlaceHolder")!
    }
}
