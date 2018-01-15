//
//  NavigationView.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 20/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NavigationView: UIView {

    var titleLabel: UILabel!
    var loadingView: UIView!
    var activityIndicatorView: UIActivityIndicatorView!
    var loadingLayer: CAShapeLayer!
    var roundLayer: CAShapeLayer!
    
    let loadingWidth: CGFloat = 15
    
    var isLoading: Bool = false
    
    var homeViewModel: HomeViewModel? {
        didSet { RxConfiguration() }
    }
    
    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: statusBarHeight + navigationBarHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    func buildView() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(statusBarHeight/2)
        }
        titleLabel.text = "今日热闻"
        titleLabel.textColor = UIColor.white
        
        loadingView = UIView()
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-10)
            make.width.height.equalTo(loadingWidth)
        }
        //旋转loadingView是起始位置在下面开始
        loadingView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        //默认大小 20 * 20 ,也可以通过frame设置大小
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(loadingView)
        }
        activityIndicatorView.stopAnimating()
        
        // roundLayer
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: loadingWidth, height: loadingWidth))
        
        roundLayer = CAShapeLayer()
        roundLayer.path = path.cgPath
        roundLayer.lineWidth = 1
        roundLayer.strokeColor = UIColor(rgb: (240,240,240))?.withAlphaComponent(0.5).cgColor
        roundLayer.fillColor = UIColor.clear.cgColor
        roundLayer.strokeStart = 0
        roundLayer.strokeEnd = 1
        loadingView.layer.addSublayer(roundLayer)
        
        //loadingLayer
        loadingLayer = CAShapeLayer()
        loadingLayer.path = path.cgPath
        loadingLayer.lineWidth = 1
        loadingLayer.strokeColor = UIColor.white.cgColor
        loadingLayer.fillColor = UIColor.clear.cgColor
        loadingLayer.strokeStart = 0
        loadingLayer.strokeEnd = 0
        loadingView.layer.addSublayer(loadingLayer)
    }
    
    
    func updateWithContentOffsetY(_ y: CGFloat) {
        if y >= 0 && y <= Config.HomeController.topStoryViewHeight {
            backgroundColor = themeColor?.withAlphaComponent(y / (Config.HomeController.topStoryViewHeight - statusBarHeight - navigationBarHeight))
            loadingView.isHidden = true
            isLoading = false
            loadingLayer.strokeEnd = CGFloat(0)
        } else if y < 0   {
            if !isLoading {
                loadingView.isHidden = false
            }
            loadingLayer.strokeEnd = CGFloat(fabsf(Float(y / Config.HomeController.refreshOffsetY)))
        }
    }
    
    func RxConfiguration() {

        homeViewModel?.tableViewContentOffsetY
            .drive(onNext: { [weak self] y in
                self?.updateWithContentOffsetY(y)
            })
            .disposed(by: disposeBag)
        
        homeViewModel?.refreshLoading
            .do(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.isHidden = true
                    self?.isLoading = true
                }
            })
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
