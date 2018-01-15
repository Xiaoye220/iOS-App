//
//  HomeViewModel.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 20/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    
    var tableViewContentOffsetY: Driver<CGFloat>
    var refreshLoading: Driver<Bool>
    var initLoading: Driver<Bool>
    var beforeStoriesLoading: Driver<Bool>
    
    var latestStories: Observable<Stories>
    var topStoriesImages: Observable<(Int, UIImage)>
    var beforeStories = Variable<Stories?>(nil)

    init(tableView: UITableView) {
        let API = ZhiHuDefaultAPI.shared
        let refreshLoadingActivityIndicator = ActivityIndicator()
        let initLoadingActivityIndicator = ActivityIndicator()
        let beforeStoriesLoadingActivityIndicator = ActivityIndicator()
        
        self.tableViewContentOffsetY = tableView.rx.contentOffset
            .asDriver()
            .map{ $0.y }
        
        self.refreshLoading = refreshLoadingActivityIndicator.asDriver()
        self.initLoading = initLoadingActivityIndicator.asDriver()
        self.beforeStoriesLoading = beforeStoriesLoadingActivityIndicator.asDriver()
        
        self.latestStories = {
            let refresh_latestStories = tableView.rx.didEndDragging
                .filter { _ in
                    return tableView.contentOffset.y < Config.HomeController.refreshOffsetY
                }
                .flatMapLatest { _ in
                    return API.getLatestStory()
                        .trackActivity(refreshLoadingActivityIndicator)
            }
            
            let init_latestStories = API.getLatestStory()
                .trackActivity(initLoadingActivityIndicator)
            
            let latestStories = Observable.of(refresh_latestStories, init_latestStories)
                .merge()
                .share(replay: 1, scope: .whileConnected)
            
            return latestStories
        }()
        
        self.topStoriesImages = latestStories
            .map{ $0.top_stories.map{ $0.image! } }
            .flatMapLatest { urls in
                return API.getImages(urls)
            }
            .share(replay: 1, scope: .whileConnected)
        
        // beforeStories
        do {
            let willLoadBeforeStories = Observable.combineLatest(tableViewContentOffsetY.asObservable(), beforeStoriesLoading.asObservable()) { return ($0, $1) }
                .map { (y, isloading) -> Bool in
                    // 到底前两个 Cell 开始 load 新的 story
                    return y >= (tableView.contentSize.height - screenHeight - 2 * Config.HomeController.rowHeight) && !isloading
                }
                .throttle(0.3, scheduler: MainScheduler.instance)
                .distinctUntilChanged()
            
            Observable.combineLatest(willLoadBeforeStories, latestStories) { return ($0, $1) }
                .filter { $0.0 }
                .flatMapLatest { [weak self] (bool, latestStories) -> Observable<Stories> in
                    guard let welf = self else { return Observable.empty() }
                    let date = welf.beforeStories.value == nil ? latestStories.date : welf.beforeStories.value?.date
                    return API.getBeforeStory(date!)
                        .trackActivity(beforeStoriesLoadingActivityIndicator)
                        .map { return $0 }
                        .asObservable()
                }
                .share(replay: 1, scope: .whileConnected)
                .bind(to: beforeStories)
                .disposed(by: disposeBag)
        }
        
        
    }
    
    
    
}
