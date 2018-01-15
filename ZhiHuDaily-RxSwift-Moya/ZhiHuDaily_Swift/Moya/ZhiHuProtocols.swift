//
//  ZhiHuProtocols.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 17/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


enum ZhiHuError: String {
    case ParseJSONError
    case GetLatestStoriesError
    case GetBeforeStoriesError
    case GetImageError
}

extension ZhiHuError: Swift.Error { }


protocol ZhiHuAPI {
    func getLatestStory() -> Single<Stories>
    func getBeforeStory(_ date: String) -> Single<Stories>
    func getImage(_ url: String) -> Single<UIImage>
    func getImages(_ urls: [String]) -> Observable<(Int, UIImage)>
    func getStoryDetail(_ id: Int) -> Single<StoryDetail>
    func getCss(_ urls: [String]) -> Observable<[String]>
}
