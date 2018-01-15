//
//  TopStoryView.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 10/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit
import Moya

protocol HomeTopStoryViewDelegate: class {
    func homeTopStoryViewDidTap(_ index: Int, storyId: Int)
}

class HomeTopStoryView: UIView {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var imageViews: [UIImageView] = []
    var labels: [UILabel] = []
    
    var timer: Timer!
    
    weak var delegate: HomeTopStoryViewDelegate?
    
    /// 滚动间隔
    var timeInterval: Double = 3 {
        didSet{
            stopScroll()
            startScroll()
        }
    }
    
    /// pageControl圆圈的颜色
    var pageIndicatorTintColor: UIColor = UIColor.lightGray {
        didSet { pageControl.pageIndicatorTintColor = pageIndicatorTintColor }
    }
    
    /// pageControl选中的圆圈的颜色
    var currentPageIndicatorTintColor: UIColor = UIColor.white {
        didSet { pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor }
    }
    
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
    
    var placeHoldImage = Config.TopStoryView.placeHoldImage
    
    var imageHeight: CGFloat
    var pageCount: Int
    var images: [UIImage]
    var labelTexts: [String]
    
    var homeViewModel: HomeViewModel? {
        didSet { RxConfiguration() }
    }
    
    init(frame: CGRect, imageHeight: CGFloat, pageCount: Int) {
        self.imageHeight = imageHeight
        self.pageCount = pageCount
        self.images = Array(repeating: placeHoldImage, count: pageCount)
        self.labelTexts = Array(repeating: String(), count: pageCount)
        
        super.init(frame: frame)
        
        setupScrollView()
        setupPageControl()
        setupImageViews()
        setupLabels()
        
        startScroll()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(frame.height - imageHeight)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        scrollView.contentSize = CGSize(width: 3 * frame.width, height: frame.height)
        scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: false)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        // 禁止反弹效果，隐藏滚动条
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
    }
    
    func setupPageControl() {
        pageControl = UIPageControl()
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).offset(10)
        }
        
        pageControl.numberOfPages = pageCount
        let pageControlSize = pageControl.size(forNumberOfPages: pageCount)
        pageControl.frame = CGRect(x: 0, y: 0, width: pageControlSize.width, height: pageControlSize.height)
        
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }
    
    func setupImageViews() {
        for i in 0 ..< 3 {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: imageHeight))
            scrollView.addSubview(imageView)
            imageView.image = placeHoldImage
            imageView.contentMode = .scaleAspectFill
            imageViews.append(imageView)
            setupCAGradientLayer(imageView)
        }
    }
    
    func setupLabels() {
        for i in 0 ..< 3 {
            let label = UILabel()
            scrollView.addSubview(label)
            label.snp.makeConstraints { make in
                make.leading.equalTo(scrollView).offset(10 + CGFloat(i) * frame.width)
                make.width.equalTo(frame.width - 20)
                make.bottom.equalTo(self).offset(-20)
            }
            label.numberOfLines = 0

            labels.append(label)
        }
    }
    
    func setupCAGradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HomeTopStoryView {
    
    // MARK: - 图片自动滚动
    func startScroll() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(pageScroll), userInfo: nil, repeats: true)
    }
    func stopScroll() {
        timer.invalidate()
    }
    func pauseScroll() {
        timer.fireDate = Date.distantFuture
    }
    func resumeScroll() {
        timer.fireDate = Date(timeIntervalSinceNow: timeInterval)
    }
    
    @objc func pageScroll() {
        scrollLeft()
    }
    func scrollLeft() {
        scrollView.setContentOffset(CGPoint.init(x: frame.width * 2, y: 0), animated: true)
    }
    func scrollRight() {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
}


extension HomeTopStoryView: UIScrollViewDelegate {
    var leftPage: Int { return (currentPage + pageCount - 1) % pageCount}
    var rightPage: Int { return (currentPage + 1) % pageCount }
    var currentPage: Int {
        get { return pageControl.currentPage }
        set { pageControl.currentPage = newValue }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageExchange()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageExchange()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pauseScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resumeScroll()
    }
    
    func pageExchange() {
        let xOffset = scrollView.contentOffset.x
        if xOffset == 0 {
            currentPage = leftPage
        } else if xOffset  == frame.width * 2 {
            currentPage = rightPage
        }
        imageViews[1].image = images[currentPage]
        labels[1].attributedText = NSAttributedString(string: labelTexts[currentPage], attributes: labelAttr)
        scrollView.setContentOffset(CGPoint.init(x: frame.width, y: 0), animated: false)
        
        imageViews[0].image = images[leftPage]
        labels[0].attributedText = NSAttributedString(string: labelTexts[leftPage], attributes: labelAttr)
        
        imageViews[2].image = images[rightPage]
        labels[2].attributedText = NSAttributedString(string: labelTexts[rightPage], attributes: labelAttr)
    }
}


extension HomeTopStoryView {
    func RxConfiguration() {
        homeViewModel?.latestStories
            .map { $0.top_stories.map{ $0.title! } }
            .subscribe(onNext: { [weak self] titles in
                guard let welf = self else { return }
                if welf.labelTexts.count == titles.count {
                    welf.labelTexts = titles
                    welf.labels[0].attributedText = NSAttributedString(string: titles[welf.leftPage], attributes: welf.labelAttr)
                    welf.labels[1].attributedText = NSAttributedString(string: titles[welf.currentPage], attributes: welf.labelAttr)
                    welf.labels[2].attributedText = NSAttributedString(string: titles[welf.rightPage], attributes: welf.labelAttr)
                }
            })
            .disposed(by: disposeBag)
        
        homeViewModel?.topStoriesImages
            .subscribe(onNext: { [weak self] (index, image) in
                guard let welf = self else { return }
                welf.images[index] = image
                if welf.currentPage == index {
                    welf.imageViews[1].image = image
                }else if welf.leftPage == index {
                    welf.imageViews[0].image = image
                }else if welf.rightPage == index {
                    welf.imageViews[2].image = image
                }
            })
            .disposed(by: disposeBag)
        
        homeViewModel?.tableViewContentOffsetY
            .filter{ [weak self] y in
                guard let welf = self else { return false }
                return y <= 0 && y >= (welf.frame.height - welf.imageHeight )
            }
            .drive(onNext: { [weak self] y in
                guard let welf = self else { return }
                welf.imageViews.forEach{ imageView in
                    imageView.setY(y: (welf.imageHeight - welf.frame.height - abs(y)) / 2 )
                }
            })
            .disposed(by: disposeBag)
        
        // UITapGestureRecognizer
        do {
            let tap = UITapGestureRecognizer()
            self.addGestureRecognizer(tap)
            tap.rx.event
                .withLatestFrom(homeViewModel!.latestStories)
                .map{ $0.top_stories }
                .subscribe(onNext: { [weak self] topStories in
                    guard let welf = self else { return }
                    welf.delegate?.homeTopStoryViewDidTap(welf.currentPage, storyId: topStories[welf.currentPage].id)
                })
                .disposed(by: disposeBag)
        }
    }
    
}
