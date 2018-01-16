//
//  SettingViewModel.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/15.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel {
    
    // 判断是否在执行答题功能
    var isPlaying = Variable<Bool>(false)
    
    var game = Variable<Game>(MySetting.game)
    var questionRect = Variable<CGRect>(MySetting.questionRect)
    var duration = Variable<Duration>(MySetting.duration)
    var searchMode = Variable<SearchMode>(MySetting.searchMode)
    
    init() {
        game.asDriver()
            .skip(1)
            .drive(onNext: { game in
                MySetting.game = game
            })
            .disposed(by: disposeBag)
        
        questionRect.asDriver()
            .skip(1)
            .drive(onNext: { rect in
                MySetting.questionRect = rect
            })
            .disposed(by: disposeBag)
        
        duration.asDriver()
            .skip(1)
            .drive(onNext: { duration in
                MySetting.duration = duration
            })
            .disposed(by: disposeBag)
        
        searchMode.asDriver()
            .skip(1)
            .drive(onNext: { searchMode in
                MySetting.searchMode = searchMode
            })
            .disposed(by: disposeBag)
    }
    
}
