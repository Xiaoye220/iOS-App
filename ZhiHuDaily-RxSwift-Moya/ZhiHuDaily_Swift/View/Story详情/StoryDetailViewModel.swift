//
//  StoryDetailViewModel.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 27/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import RxDataSources

class StoryDetailViewModel {
    
    var storyId: Variable<Int>!
    
    var webViewContentOffsetY: Driver<CGFloat>
    var loading: Driver<Bool>

    var storyDetail: Observable<StoryDetail>
    var html: Observable<String>
    var showStatusBar: Driver<Bool>

    var headerImage: Observable<UIImage>
    var headerTitleAndImageSource: Driver<(title: String, imageSource: String)>
    var arrowIsUp: Driver<Bool>
    var isFirstStory: Driver<Bool>
    var willBeginLoadPreviousStory: Driver<Void>
    var didBeginLoadPreviousStory: Driver<Void>

    init(storyId: Int, storyIds: [[Int]], webView: UIWebView) {
        let API = ZhiHuDefaultAPI.shared
        let loadingActivityIndicator = ActivityIndicator()

        self.storyId = Variable<Int>(storyId)
        
        webViewContentOffsetY = webView.scrollView.rx.contentOffset.asDriver().map{ $0.y }
        
        loading = loadingActivityIndicator.asDriver()
        
        storyDetail = self.storyId.asObservable()
            .flatMapLatest({ storyId in
                return API.getStoryDetail(storyId)
                .trackActivity(loadingActivityIndicator)
                .share(replay: 1, scope: .whileConnected)
            })
        
        // web html
        do {
            let css = storyDetail.flatMapLatest { storyDetail -> Observable<[String]> in
                    return API.getCss(storyDetail.css)
                        .trackActivity(loadingActivityIndicator)
                }
                .share(replay: 1, scope: .whileConnected)
            
            html = Observable.combineLatest(storyDetail, css) { return ($0, $1) }
                .map { (storyDetail, css) -> String in
                    let c = css.reduce(String()) { (result, string) -> String in
                        return "\(result)\(string)\n"
                    }
                    return "<html><head><style> \(c) </style></head> <body> \(storyDetail.body!) </body></html>"
            }
        }
        
        // headerView
        do {
            headerImage = storyDetail.map { $0.image! }
                .flatMapLatest { url -> Observable<UIImage> in
                    return API.getImage(url)
                        .asObservable()
                }
                .share(replay: 1, scope: .whileConnected)
            
            headerTitleAndImageSource = storyDetail.map { ($0.title!, $0.image_source!) }
                .asDriver(onErrorJustReturn: (String(), String()))
        }
        
        showStatusBar = webViewContentOffsetY.map{ $0 > Config.StoryDetailController.headerViewHeight - statusBarHeight }
            .distinctUntilChanged()
        
        arrowIsUp = webViewContentOffsetY.map{ $0 > Config.StoryDetailController.headerViewArrowRotateOffsetY }
            .distinctUntilChanged()
        
        isFirstStory = self.storyId.asObservable()
            .map{ return storyIds.first?.first == $0 }
            .asDriver(onErrorJustReturn: false)
        
        willBeginLoadPreviousStory = webView.scrollView.rx.willEndDragging
            .withLatestFrom(arrowIsUp)
            .filter{ !$0 }
            .withLatestFrom(isFirstStory)
            .filter{ !$0 }
            .map { _ in }
            .asDriver(onErrorJustReturn:())
        
        didBeginLoadPreviousStory = Driver.zip(webView.scrollView.rx.didEndDragging.asDriver(), willBeginLoadPreviousStory) { _,_ in }

        didBeginLoadPreviousStory.withLatestFrom(self.storyId.asDriver())
            .map { ArrayUtils.findPreviousElementInIdyadicArray(storyIds, element: $0) }
            .drive(onNext: { [weak self] storyId in
                if let storyId = storyId {
                    self?.storyId.value = storyId
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
