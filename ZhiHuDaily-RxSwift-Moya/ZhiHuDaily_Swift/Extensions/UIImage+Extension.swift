//  *
//  UIImageExtension.swift
//  Inonev
//
//  Created by YZF on 2016/12/28.
//  Copyright © 2016年 YZF. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 截屏
    class func captureScreen() -> UIImage {
        let window = UIApplication.shared.keyWindow!
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, UIScreen.main.scale)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    /// 缩放
    ///
    /// - Parameter to: 缩放到指定尺寸
    func imageByScaling(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 裁剪,将原图缩放到整个屏幕大小后裁剪指定rect大小的图片
    ///
    /// - Parameter rect: 截取指定rect的图片
    func image(at rect: CGRect) -> UIImage {
        let srcImage = cgImage
        
        let widthScale = size.width / UIScreen.main.bounds.size.width
        let heightScale = size.height / UIScreen.main.bounds.size.height
        let realRect = CGRect.init(x: rect.origin.x * widthScale, y: rect.origin.y * heightScale, width: rect.size.width * widthScale, height: rect.size.height * heightScale)
        //从原图上截取指定大小的图片，如原图为100*100，rect为（0，0，50，50），那么会截取左上角四分之一的图片
        let imageRef = srcImage!.cropping(to: realRect);
        let subImage = UIImage.init(cgImage: imageRef!)
        return subImage.imageByScaling(to: rect.size)
        
    }
    
    
    /// 按较大边缩放图片
    ///
    /// - Parameter targetSize: 缩放的目标大小
    func imageByScalingAspectToMaxSize(targetSize: CGSize) -> UIImage {
        let imageSize = size
        let width = imageSize.width
        let height = imageSize.height
        
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var anchorPoint = CGPoint.zero
        
        if(!imageSize.equalTo(targetSize))
        {
            let xFactor = targetWidth/width
            let yFactor = targetHeight/height
            let scaleFactor = (xFactor < yFactor) ? xFactor : yFactor
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if(xFactor < yFactor)
            {
                anchorPoint.y = (targetHeight - scaledHeight) / 2
            }
            else if(xFactor > yFactor)
            {
                anchorPoint.x = (targetWidth - scaledWidth) / 2
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        var anchorRect = CGRect.zero
        anchorRect.origin = anchorPoint
        anchorRect.size.width = scaledWidth
        anchorRect.size.height = scaledHeight
        draw(in: anchorRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    /// 将多个image组合成一幅image，横向组合
    ///
    /// - Parameters:
    ///   - images: image数组
    ///   - size: 规定每个image的size
    class func imageByCombiningImagesHorizontal(images: [UIImage], perPageSize size: CGSize) -> UIImage {
        let imageCount = images.count
        let imageSize = CGSize.init(width: size.width*CGFloat(imageCount), height: size.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        for i in 0 ..< imageCount {
            let rect = CGRect.init(x: CGFloat(i)*size.width, y: 0, width: size.width, height: size.height)
            images[i].draw(in: rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


