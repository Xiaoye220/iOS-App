//
//  StoryDetailHeaderView.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 1/11/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit

class StoryDetailHeaderView: UIView {

    var imageView: UIImageView!
    var titleLabel: UILabel!
    var imageSourceLabel: UILabel!
    var upLabel: UILabel!
    var arrowIcon: UILabel!
    
    var imageTopConstraint: Constraint?

    
    var storyDetailViewModel: StoryDetailViewModel! {
        didSet { RxConfiguration() }
    }

    let viewHeight = Config.StoryDetailController.headerViewHeight
    let imageHeight = Config.StoryDetailController.headerImageViewHeight
    
    lazy var labelAttr: [NSAttributedStringKey: Any] = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadow.shadowColor = UIColor.black
        
        var attr: [NSAttributedStringKey: Any] = [:]
        attr[.shadow] = shadow
        attr[.font] = UIFont.boldSystemFont(ofSize: Config.HomeController.topStoryFontSize)
        attr[.foregroundColor] = UIColor.white
        return attr
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: Config.StoryDetailController.headerViewHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        let bgView = UIView()
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().offset(viewHeight - imageHeight)
        }
        bgView.clipsToBounds = true
        
        imageView = UIImageView()
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.trailing.leading.equalToSuperview()
            self.imageTopConstraint = make.top.equalToSuperview().constraint
        }
        imageView.contentMode = .scaleAspectFill
        imageView.image = Config.StoryDetailController.headerViewPlaceHoldImage
        setupCAGradientLayer(imageView, frame: CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight))
        
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-20)
        }
        titleLabel.numberOfLines = 0
        
        imageSourceLabel = UILabel()
        addSubview(imageSourceLabel)
        imageSourceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        imageSourceLabel.textColor = UIColor.white
        imageSourceLabel.font = UIFont.systemFont(ofSize: Config.StoryDetailController.headerViewImageSourceFontSize)
        
        upLabel = UILabel()
        bgView.addSubview(upLabel)
        upLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        upLabel.textColor = .white
        upLabel.font = UIFont.systemFont(ofSize: Config.StoryDetailController.headerViewUpLabelFontSize)
        
        arrowIcon = UILabel()
        bgView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalTo(upLabel.snp.centerY)
            make.leading.equalTo(upLabel.snp.leading)
        }
        arrowIcon.iconFont(20, icon: .arrow, color: .white)
    }
    
    func setupCAGradientLayer(_ view: UIView, frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        //设置渐变的颜色
        gradientLayer.colors = [UIColor(white: 0, alpha: 0.5).cgColor,
                                UIColor.clear.cgColor,
                                UIColor(white: 0, alpha: 0.5).cgColor]
        //设置渐变的区间分布 0~1
        gradientLayer.locations = [0, 0.5, 1]
        //设置渐变的起始、终止位置 (0,0)左上角 （1，1）右下角
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func RxConfiguration() {
        storyDetailViewModel.webViewContentOffsetY
            .filter{ [weak self] y in
                guard let welf = self else { return false }
                return y <= 0 && y >= (welf.viewHeight - welf.imageHeight )
            }
            .drive(onNext: { [weak self] y in
                guard let welf = self else { return }
                welf.imageTopConstraint?.update(offset: (welf.imageHeight - welf.viewHeight - abs(y)) / 2)
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.headerImage
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        storyDetailViewModel.headerTitleAndImageSource
            .drive(onNext: { [weak self] (title, imageSource) in
                self?.titleLabel.attributedText = NSAttributedString(string: title, attributes: self?.labelAttr)
                self?.imageSourceLabel.text = "图片：" + imageSource
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.arrowIsUp
            .drive(onNext: { [weak self] up in
                UIView.animate(withDuration: 0.2, animations: {
                    self?.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(up ? 0 : Double.pi))
                })
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.isFirstStory
            .drive(onNext: { [weak self] isFirstStory in
                self?.upLabel.text = isFirstStory ? "已经是第一篇了" :  "      载入上一篇"
                self?.arrowIcon.isHidden = isFirstStory
            })
            .disposed(by: disposeBag)
        
        storyDetailViewModel.didBeginLoadPreviousStory
            .drive(onNext: { [weak self] _ in
                self?.imageView.image = Config.StoryDetailController.headerViewPlaceHoldImage
            })
            .disposed(by: disposeBag)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
