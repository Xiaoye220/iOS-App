//
//  ZhiHuAPI.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 11/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import UIKit

class ZhiHuDefaultAPI: ZhiHuAPI {
    
    static let shared = ZhiHuDefaultAPI()
    
    private let provider = MoyaProvider<ZhiHu>()
    
    func getLatestStory() -> Single<Stories> {
        return provider.rx.request(.latestStories)
            .filterSuccessfulStatusCodes()
            .mapString()
            .map { jsonString -> Stories in
                guard let stories = Stories.deserialize(from: jsonString) else {
                    throw ZhiHuError.ParseJSONError
                }
                return stories
            }
            .retry(2)
    }
    
    func getBeforeStory(_ date: String) -> Single<Stories> {
        return provider.rx.request(.beforeStories(date: date))
            .filterSuccessfulStatusCodes()
            .mapString()
            .map { jsonString -> Stories in
                guard let stories = Stories.deserialize(from: jsonString) else {
                    throw ZhiHuError.ParseJSONError
                }
                return stories
            }
            .retry(2)
    }
    
    func getImage(_ url: String) -> Single<UIImage> {
        return provider.rx.request(.image(url: url))
            .filterSuccessfulStatusCodes()
            .mapImage()
            .map { image -> UIImage in
                guard let image = image else {
                    throw ZhiHuError.GetImageError
                }
                return image
            }
            .retry(2)
    }
    
    func getImages(_ urls: [String]) -> Observable<(Int, UIImage)> {
        return Observable.create{ [weak self] observer in
            guard let welf = self else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            for (index, url) in urls.enumerated() {
                welf.getImage(url)
                    .subscribe(onSuccess: { image in
                        observer.on(.next((index, image)))
                    }, onError: { error in
                        observer.on(.error(error))
                    })
                    .disposed(by: disposeBag)
            }
            
            return Disposables.create()
        }
    }
    
    func getStoryDetail(_ id: Int) -> Single<StoryDetail> {
        return provider.rx.request(.storyDetail(id: id))
            .filterSuccessfulStatusCodes()
            .mapString()
            .map { jsonString -> StoryDetail in
                guard let storyDetail = StoryDetail.deserialize(from: jsonString) else {
                    throw ZhiHuError.ParseJSONError
                }
                return storyDetail
            }
            .retry(2)
    }
    
    func getString(_ url: String) -> Single<String> {
        return provider.rx.request(.string(url: url))
            .filterSuccessfulStatusCodes()
            .mapString()
            .retry(2)
    }
    
    func getCss(_ urls: [String]) -> Observable<[String]> {
        return Observable.from(urls)
            .flatMap { [weak self] url -> Observable<String> in
                guard let welf = self else { return Observable.empty() }
                return welf.getString(url).asObservable()
            }
            .toArray()
    }
    
}
