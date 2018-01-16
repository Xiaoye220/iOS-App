//  *
//  UIImageExtension.swift
//  Inonev
//
//  Created by YZF on 2016/12/28.
//  Copyright © 2016年 YZF. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 裁剪,将原图缩放到整个屏幕大小后裁剪指定rect大小的图片
    ///
    /// - Parameter rect: 截取指定rect的图片
    func cropping(to rect: CGRect) -> UIImage {
        let scale = UIScreen.main.scale
        let realRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        let srcImage = cgImage
        //从原图上截取指定大小的图片，如原图为100*100，rect为（0，0，50，50），那么会截取左上角四分之一的图片
        let imageRef = srcImage!.cropping(to: realRect)
        let subImage = UIImage(cgImage: imageRef!, scale: scale, orientation: .up)
        return subImage
    }
    
    
}


