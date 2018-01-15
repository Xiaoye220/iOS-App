//
//  StoryDetailViewController.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 27/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa

class StoryDetailViewController: BaseViewController, UIGestureRecognizerDelegate {

    var storyDetailViewModel: StoryDetailViewModel!
    var storyId: Int!
    var storyIds: [[Int]]!
    
    var webView: UIWebView!
    var headerView: StoryDetailHeaderView!
    var statusBarView: UIView!
    var captureScreenImageView: UIImageView!
    
    var captureScreen = UIImage()
    
    let headerViewHeight = Config.StoryDetailController.headerViewHeight
    let headerImageViewHeight = Config.StoryDetailController.headerImageViewHeight
    let cssImageHolderHeight = Config.StoryDetailController.cssImageHolderHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        RxConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationSetting.hidesBackButton(true)
            .enableInteractivePopGestureRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupView() {
        webView = UIWebView()
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(headerViewHeight - cssImageHolderHeight)
        }
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(headerViewHeight, 0, 0, 0)
        
        headerView = StoryDetailHeaderView()
        view.addSubview(headerView)
        
        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        view.addSubview(statusBarView)
        
        captureScreenImageView = UIImageView()
        view.addSubview(captureScreenImageView)
        captureScreenImageView.snp.makeConstraints { make in
            make.leading.trailing.height.equalToSuperview()
            make.top.equalToSuperview().offset(screenHeight)
        }
    }

    func RxConfiguration() {
        storyDetailViewModel = StoryDetailViewModel(storyId: storyId, storyIds: storyIds, webView: webView)
        headerView.storyDetailViewModel = storyDetailViewModel
        
        storyDetailViewModel.html
            .subscribe(onNext: { [weak self] html in
                self?.webView.loadHTMLString(html, baseURL: nil)
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.webViewContentOffsetY
            .drive(onNext: { [weak self] y in
                guard let welf = self else { return }
                let minOffsetY = welf.headerViewHeight - welf.headerImageViewHeight
                if y <= minOffsetY {
                    self?.webView.scrollView.setContentOffset(CGPoint(x: 0, y: minOffsetY), animated: false)
                } else if y <= welf.headerViewHeight {
                    self?.headerView.setY(y: -y)
                    self?.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(welf.cssImageHolderHeight - y, 0, 0, 0)
                }
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.showStatusBar
            .drive(onNext: { [weak self] b in
                self?.statusBarView.backgroundColor = b ? UIColor.white : UIColor.clear
                UIApplication.shared.setStatusBarStyle(b ? .default : .lightContent, animated: true)
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
      
        storyDetailViewModel.willBeginLoadPreviousStory
            .drive(onNext: { [weak self] _ in
                self?.captureScreen = UIImage.captureScreen()
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.didBeginLoadPreviousStory
            .drive(onNext: { [weak self] _ in
                self?.captureScreenImageView.image = self?.captureScreen
                self?.view.setY(y: -screenHeight)
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.setY(y: 0)
                })
                self?.webView.loadHTMLString(String(), baseURL: nil)
            })
            .disposed(by: disposeBag)
    }
    

}
