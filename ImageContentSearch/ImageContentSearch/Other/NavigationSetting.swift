//
//  NavigationSetting.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 18/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit


class NavigationSetting {
    
    fileprivate weak var vc: UIViewController?
    var navigationBarView: UIView!
    var statusBarView: UIView!
    
    init(_ vc: UIViewController) {
        self.vc = vc
    }
    
    // MARK: - navigationItem
    fileprivate var title: String? {
        didSet { vc?.navigationItem.title = title }
    }
    
    fileprivate var prompt: String? {
        didSet { vc?.navigationItem.prompt = prompt }
    }
    
    fileprivate var titleView: UIView? {
        didSet { vc?.navigationItem.titleView = titleView }
    }
    
    fileprivate var hidesBackButton: Bool = false {
        didSet { vc?.navigationItem.hidesBackButton = hidesBackButton }
    }
    
    fileprivate var backBarButtonItemTitle: String? {
        didSet {
            let backItem = UIBarButtonItem(title: backBarButtonItemTitle, style: .plain, target: nil, action: nil)
            vc?.navigationItem.backBarButtonItem = backItem
        }
    }
    
    fileprivate var backBarButtonItemImage: UIImage? {
        didSet {
            let backItem = UIBarButtonItem(image: backBarButtonItemImage, style: .plain, target: nil, action: nil)
            vc?.navigationItem.backBarButtonItem = backItem
        }
    }
    
    fileprivate var leftBarButtonItem: UIBarButtonItem? {
        didSet { vc?.navigationItem.leftBarButtonItem = leftBarButtonItem }
    }
    
    fileprivate var leftBarButtonItems: [UIBarButtonItem]? {
        didSet { vc?.navigationItem.leftBarButtonItems = leftBarButtonItems }
    }
    
    fileprivate var rightBarButtonItem: UIBarButtonItem? {
        didSet { vc?.navigationItem.rightBarButtonItem = rightBarButtonItem }
    }
    
    fileprivate var rightBarButtonItems: [UIBarButtonItem]? {
        didSet { vc?.navigationItem.rightBarButtonItems = rightBarButtonItems }
    }
    
    // MARK: - navigationBar

    fileprivate var titleColor: UIColor = .black {
        didSet {
            if let _ = vc?.navigationController?.navigationBar.titleTextAttributes {
                vc?.navigationController?.navigationBar.titleTextAttributes![NSAttributedStringKey.foregroundColor] = titleColor
            }
            vc?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor]
        }
    }
    
    fileprivate var tintColor: UIColor = .black {
        didSet { vc?.navigationController?.navigationBar.tintColor = tintColor }
    }
    
    fileprivate var isTranslucent: Bool = true {
        didSet { vc?.navigationController?.navigationBar.isTranslucent = isTranslucent }
    }
    
    fileprivate var backgroundImage: UIImage? {
        didSet { vc?.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default) }
    }
    
    fileprivate var shadowImage: UIImage? {
        didSet { vc?.navigationController?.navigationBar.shadowImage = shadowImage }
    }
    
    fileprivate var titleTextAttributes: [NSAttributedStringKey : Any]? {
        didSet {
           vc?.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    fileprivate var titleVerticalPositionAdjustment: CGFloat = 0 {
        didSet {
            vc?.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(titleVerticalPositionAdjustment, for: .default)
        }
    }
}

extension NavigationSetting {
    // MARK: - navigationItem
    @discardableResult
    func title(_ title: String?) -> NavigationSetting {
        self.title = title
        return self
    }
    
    @discardableResult
    func prompt(_ prompt: String?) -> NavigationSetting {
        self.prompt = prompt
        return self
    }
    
    @discardableResult
    func titleView(_ titleView: UIView?) -> NavigationSetting {
        self.titleView = titleView
        return self
    }
    
    @discardableResult
    func hidesBackButton(_ hidesBackButton: Bool) -> NavigationSetting {
        self.hidesBackButton = hidesBackButton
        return self
    }

    @discardableResult
    func backBarButtonItemTitle(_ backBarButtonItemTitle: String?) -> NavigationSetting {
        self.backBarButtonItemTitle = backBarButtonItemTitle
        return self
    }
    
    @discardableResult
    func backBarButtonItemImage(_ backBarButtonItemImage: UIImage?) -> NavigationSetting {
        self.backBarButtonItemImage = backBarButtonItemImage
        return self
    }
    
    @discardableResult
    func leftBarButtonItem(_ leftBarButtonItem: UIBarButtonItem?) -> NavigationSetting {
        self.leftBarButtonItem = leftBarButtonItem
        return self
    }
    
    @discardableResult
    func leftBarButtonItems(_ leftBarButtonItems: [UIBarButtonItem]?) -> NavigationSetting {
        self.leftBarButtonItems = leftBarButtonItems
        return self
    }
    
    @discardableResult
    func rightBarButtonItem(_ rightBarButtonItem: UIBarButtonItem?) -> NavigationSetting {
        self.rightBarButtonItem = rightBarButtonItem
        return self
    }
    
    @discardableResult
    func rightBarButtonItems(_ rightBarButtonItems: [UIBarButtonItem]?) -> NavigationSetting {
        self.rightBarButtonItems = rightBarButtonItems
        return self
    }
    
    
    // MARK: - navigationBar
    @discardableResult
    func titleColor(_ titleColor: UIColor) -> NavigationSetting {
        self.titleColor = titleColor
        return self
    }

    @discardableResult
    func tintColor(_ tintColor: UIColor) -> NavigationSetting {
        self.tintColor = tintColor
        return self
    }

    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> NavigationSetting {
        self.isTranslucent = isTranslucent
        return self
    }
    
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> NavigationSetting {
        self.backgroundImage = backgroundImage
        return self
    }

    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> NavigationSetting {
        self.shadowImage = shadowImage
        return self
    }

    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedStringKey : Any]?) -> NavigationSetting {
        self.titleTextAttributes = titleTextAttributes
        return self
    }

    @discardableResult
    func titleVerticalPositionAdjustment(_ titleVerticalPositionAdjustment: CGFloat) -> NavigationSetting {
        self.titleVerticalPositionAdjustment = titleVerticalPositionAdjustment
        return self
    }

}

extension NavigationSetting {
    
    /// 设置 NavigationBar 透明
    @discardableResult
    func setNavigationBarClear() -> NavigationSetting {
        //去除边框阴影
        vc?.navigationController?.navigationBar.shadowImage = UIImage()
        //背景透明
        vc?.navigationController?.navigationBar.isTranslucent = true
        //背景颜色
        vc?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        return self
    }
    
    /// 自定义 NavigationBarView
    @discardableResult
    func setNavigationBarView(_ includeStatusBar: Bool = true, closure: (UIView) -> Void) -> NavigationSetting {
        if let view = navigationBarView {
            closure(view)
        } else if let rect = vc?.navigationController?.navigationBar.bounds {
            let viewHeight = rect.height + (includeStatusBar ? UIApplication.shared.statusBarFrame.height : 0)
            navigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: viewHeight))
            closure(navigationBarView)
            vc?.navigationController?.view.insertSubview(navigationBarView, at: 1)
        }
        return self
    }
    
    /// 定义 StatusBarView
    @discardableResult
    func setStatusBarView(closure: (UIView) -> Void) -> NavigationSetting {
        if let view = statusBarView {
            closure(view)
        } else {
            let rect = UIApplication.shared.statusBarFrame
            statusBarView = UIView(frame: rect)
            closure(statusBarView)
            vc?.navigationController?.view.insertSubview(statusBarView, at: 1)
        }
        return self
    }
    
    @discardableResult
    func enableInteractivePopGestureRecognizer() -> NavigationSetting {
        vc?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        vc?.navigationController?.interactivePopGestureRecognizer?.delegate = vc as? UIGestureRecognizerDelegate
        
        return self
    }
}
