

## QuestionAnswerer

### 主要功能:
通过截图对问答类app进行答案搜索

### 效果图:
![screenshot](https://github.com/Xiaoye220/iOS_SmallProgram/blob/master/QuestionAnswerer/ScreenShot/ScreenShot.gif)

### 实现原理:
1. app 运行点击开始，在后台播放无声音乐，使其一直保持在后台运行。
2. 监听截图动作，获取到截图，对截图进行裁剪获取只包含题目答案的图。
3. 通过百度 OCR 对图进行文字识别获取到题目的 String 结果。
4. 百度搜索题目，对结果中每个答案出现的次数做统计。根据结果自己判断答案。

**关键字: app 后台运行，获取截图，OCR 文字识别，获取百度搜索结果**

### 代码相关：

**重要的事：```BaiduYunOCRService```，```BaiduYunOCRService``` 中的 apikey,secretKey 记得换成自己的**

#### 1.后台持续运行

在 ```AppDelegate``` 中添加
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    // 让音乐可以在后台运行
    // 在后台播放无声的 mp3 可以保证 app 在后台也可以一直运行
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setActive(true)
        // 设置 option 为 mixWithOthers，否则打开其他带音频播放的app，本 app 的 avplayer 会停止播放，就无法保持后台一直运行了
        try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
    } catch {
        print(error)
    }
}
```

然后创建一个 ```AVPlayer```，只要 player 在 play，那么就会一直在后台运行

定时让 player 从头播放，避免播放完后在后台不运行了

```swift
self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
    self.player.seek(to: kCMTimeZero)
}
self.player.play()
```

#### 2.截图监听

通过类 ```ScreenshotPhotoService``` 实现

主要代码
```swift
//获取目前所有照片资源
self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: self.allPhotosOptions)
//监听资源改变
PHPhotoLibrary.shared().register(self)



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
```

#### 3.OCR 实现

代码中针对 OCR 有两个类

```BaiduOCRService```: [百度OCR企业版](http://apistore.baidu.com/apiworks/servicedetail/969.html?hp.com)，前200次免费

```BaiduYunOCRService```: [百度云文字识别](https://cloud.baidu.com/product/ocr)，每天有定量免费 

两个类中的 apiKey, secretKey 填写自己的
```swift
// 你自己的 apiKey 和 secretKey
let apiKey = "..."
let secretKey = "..."
```

#### 4.百度搜索

实现了两种搜索

```BaiduSearchQuestionOnlyService```: 只搜索题目

```BaiduSearchWithAnswerService```: 继承 ```BaiduSearchQuestionOnlyService```，将题目和答案组合搜索

搜索类实现了协议 ```BaiduSearchType```，里面写死了请求 url、header
```swift
protocol BaiduSearchType {
    associatedtype Result
    
    var key: String { get set }
    
    var urlString: String { get }
    
    var request: URLRequest? { get }
    
    func search(_ completion: @escaping (Result?) -> Void)
}

extension BaiduSearchType {
    var urlString: String {
        return "https://www.baidu.com/baidu?wd=\(key)&tn=monline_dg&ie=utf-8"
    }
    
    var request: URLRequest? {
        guard let encodingURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodingURL) else {
                return nil
        }
        
        //创建请求对象
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = "GET"
        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.addValue("text/html, application/xhtml+xml, */*", forHTTPHeaderField: "Accept")
        request.addValue("en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3", forHTTPHeaderField: "Accept-Language")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        return request
    }
}
```





