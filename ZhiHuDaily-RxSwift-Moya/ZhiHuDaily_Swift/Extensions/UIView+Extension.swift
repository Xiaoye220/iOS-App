//
//  UIViewExtence.swift
//  Poetry
//
//  Created by YZF on 2016/12/6.
//  Copyright © 2016年 YZF. All rights reserved.
//

import UIKit

extension UIView{
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setX(x:CGFloat) {
        self.frame = CGRect(x:x, y:self.y(), width:self.width(), height:self.height())
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setY(y:CGFloat) {
        self.frame = CGRect(x:self.x(), y:y, width:self.width(), height:self.height())
    }
    
    func width() -> CGFloat {
        return self.frame.width
    }
    
    func setWidth(width:CGFloat) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:width, height:self.height())
    }
    
    func height() -> CGFloat{
        return self.frame.height
    }
    
    func setHeight(height:CGFloat) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:self.width(), height:height)

    }
    
    func size() -> CGSize {
        return self.frame.size
    }
    
    func setSize(size: CGSize) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:size.width, height:size.height)
    }
    
    func origin() -> CGPoint {
        return self.frame.origin
    }
    
    func setOrigin(origin: CGPoint) {
        self.frame = CGRect(x:origin.x, y:origin.y, width:self.width(), height:self.height())
    }
}

