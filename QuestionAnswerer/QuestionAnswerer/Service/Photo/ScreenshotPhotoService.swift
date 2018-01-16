//
//  PhotoService.swift
//  QuestionAnswerer
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import Photos

/// 通过截图获取包含题目图片
class ScreenshotPhotoService: NSObject, PhotoType {
    
    //取得的资源结果，用来存放的PHAsset
    var assetsFetchResults: PHFetchResult<PHAsset>!
    
    //图片管理对象
    var imageManager: PHImageManager!
    
    // imageManager 请求 image 时的 option
    var imageRequestOption: PHImageRequestOptions!
    
    // fetch photo 时的 option
    var allPhotosOptions: PHFetchOptions!
    
    var status: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    weak var delegate: PhotoDelegate!
    
    override init() {
        super.init()
        
        imageManager = PHImageManager()
        
        allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        imageRequestOption = PHImageRequestOptions()
        imageRequestOption.isSynchronous = true
    }
    
    func beginObserve() {
        doWhilePHPhotoLibraryAuthorized {
            //获取目前所有照片资源
            self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: self.allPhotosOptions)
            //监听资源改变
            PHPhotoLibrary.shared().register(self)
        }
    }
    
    func endObserve() {
        doWhilePHPhotoLibraryAuthorized {
            //取消监听资源改变
            PHPhotoLibrary.shared().unregisterChangeObserver(self)
        }
    }
    
    func requestLatestPhoto(_ comletion: @escaping (UIImage?) -> Void) {
        doWhilePHPhotoLibraryAuthorized {
            //获取目前所有照片资源
            self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: self.allPhotosOptions)
            guard self.assetsFetchResults.count > 0 else {
                comletion(nil)
                return
            }
            //获取最近一张照片
            let asset = self.assetsFetchResults[0]
            //获取缩略图
            self.requestImage(with: asset) { (image, _) in
                DispatchQueue.main.async {
                    comletion(image)
                }
            }
        }
    }
    
    // 当已经获取到相册权限时执行
    func doWhilePHPhotoLibraryAuthorized(_ handle: @escaping () -> Void) {
        if status == .authorized {
            handle()
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    handle()
                }
            }
        }
    }
    
    func requestImage(with asset: PHAsset, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        self.imageManager.requestImage(for: asset,
                                       targetSize: screenSize,
                                       contentMode: .aspectFit,
                                       options: imageRequestOption) {
            resultHandler($0, $1)
        }
    }
    
}

//PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension ScreenshotPhotoService: PHPhotoLibraryChangeObserver {
    //当照片库发生变化的时候会触发
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        //获取assetsFetchResults的所有变化情况，以及assetsFetchResults的成员变化前后的数据
        guard let collectionChanges = changeInstance.changeDetails(for: self.assetsFetchResults as! PHFetchResult<PHObject>) else { return }
        
        DispatchQueue.main.async {
            //获取最新的完整数据
            if let allResult = collectionChanges.fetchResultAfterChanges as? PHFetchResult<PHAsset>{
                self.assetsFetchResults = allResult
            }
            
            if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves{
                return
            } else {
                if let insertedIndexes = collectionChanges.insertedIndexes, insertedIndexes.count > 0 {
                    print("inserted photo ")
                    //获取最后添加的图片资源
                    let asset = self.assetsFetchResults[insertedIndexes.first!]
                    //获取缩略图
                    self.requestImage(with: asset) { (image, _) in
                        DispatchQueue.main.async {
                            self.delegate?.didTakeScreenshot(image: image)
                        }
                    }
                }
            }
        }
    }
}

