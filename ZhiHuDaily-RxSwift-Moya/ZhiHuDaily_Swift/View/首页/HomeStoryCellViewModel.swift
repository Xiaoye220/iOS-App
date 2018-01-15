//
//  HomeStoryCellViewModel.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 25/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeStoryCellViewModel {
    
    var title: Driver<String>
    var image: Driver<UIImage>
    
    init(_ story: Story) {
        let API = ZhiHuDefaultAPI.shared
        
        title = Driver.just(story.title)
        
        image = API.getImage(story.images.first!)
            .asDriver(onErrorJustReturn: Config.StoryCell.placeHoldImage)
            .startWith(Config.StoryCell.placeHoldImage)
    }
    
}
