//
//  ViewController.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/11.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import MediaPlayer

class RootViewController: UIViewController {
    
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var imageView: UIImageView! 
    @IBOutlet weak var textView: UITextView!
    
    var OCRService: OCRType!
    var photoService: PhotoType!
    //var photoService = VolumeButtonPhotoService()

    var searchWithAnswerService = BaiduSearchWithAnswerService()
    var searchQuestionOnlyService = BaiduSearchQuestionOnlyService()
    
    var navigationSetting: NavigationSetting!
    
    var settingBarBurronItem: UIBarButtonItem!
        
    var viewModel: SettingViewModel!
        
    var durationTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        OCRService = BaiduYunOCRService()
        photoService = ScreenshotPhotoService()
        photoService.delegate = self

        navigationSetting = NavigationSetting(self)
        
        setupView()
        RxConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.settingBarBurronItem = UIBarButtonItem(image: UIImage.iconFont(fontSize: 25, icon: Icon.setting),
                                               style: .plain, target: self, action: #selector(settingBarBurronItemClicked(_:)))
        
        self.navigationSetting.setNavigationBarClear()
            .rightBarButtonItem(self.settingBarBurronItem)
            .tintColor(UIColor.darkGray)
            .title(MySetting.game.rawValue)

        //self.imageView.image = UIImage.iconFont(fontSize: 200, icon: Icon.imagePlaceHolder, color: UIColor.lightGray)
        
        self.controlButton.addTarget(self, action: #selector(controlButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func settingBarBurronItemClicked(_ sender: UIBarButtonItem) {
        let controller = SettingViewController()
        controller.viewModel = self.viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func controlButtonClicked(_ sender: UIButton) {
        viewModel.isPlaying.value = !viewModel.isPlaying.value
    }
    
    
}

extension RootViewController {
    
    /// RxSwift
    func RxConfiguration() {
        viewModel.isPlaying.asDriver()
            .drive(onNext: { [weak self] isPlaying in
                guard let `self` = self else { return }
                if !isPlaying {
                    self.photoService.endObserve()
                    self.controlButton.iconFont(size: 80, icon: Icon.play, color: .darkGray)
                    self.durationTimer?.invalidate()
                } else {
                    self.photoService.beginObserve()
                    self.controlButton.iconFont(size: 80, icon: Icon.pause, color: .darkGray)
                    self.durationTimer = Timer.scheduledTimer(withTimeInterval: MySetting.duration.rawValue, repeats: false) { _ in
                        self.viewModel.isPlaying.value = false
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.game.asDriver()
            .drive(onNext: { [weak self] game in
                self?.navigationItem.title = game.rawValue
            })
            .disposed(by: disposeBag)
    }
}

extension RootViewController: PhotoDelegate {
    
    // 获取到屏幕截图
    func didTakeScreenshot(image: UIImage?) {
        print("photoLibraryDidInsert")
        // 图片裁剪
        guard let image = image?.cropping(to: MySetting.questionRect) else { return }
        imageView.image = image
        
        var questionOnlyResult = String()
        var searchWithAnswerResult = String()
        
        // 对图片进行文字识别
        OCRService.OCR(with: image) { result in
            guard let r = result else { return }
            let content = self.parseOCRResult(r)
            
            let dispatchGroup = DispatchGroup()

            let searchMode = MySetting.searchMode
            if searchMode == .questionOnly || searchMode == .all {
                self.searchQuestionOnlyService.content = content
                dispatchGroup.enter()
                self.searchQuestionOnlyService.search { result in
                    if let r = result { questionOnlyResult = r }
                    dispatchGroup.leave()
                }
            }
            
            if searchMode == .questionWithAnswer || searchMode == .all {
                self.searchWithAnswerService.content = content
                dispatchGroup.enter()
                self.searchWithAnswerService.search { result in
                    if let r = result { searchWithAnswerResult = r }
                    dispatchGroup.leave()
                }
            }
            

            dispatchGroup.notify(queue: DispatchQueue.main) {
                let finalResult: String
                if questionOnlyResult.isEmpty || searchWithAnswerResult.isEmpty {
                    finalResult = questionOnlyResult + searchWithAnswerResult
                } else {
                    finalResult = questionOnlyResult + "\n" + searchWithAnswerResult
                }
                let userInfo: [AnyHashable: Any] = ["question": content.question,
                                                    "answer": content.answers.reduce(String()){ $0 + $1 + "\n" }]
                MyUserNotifications.notification(title: "", body: "\(finalResult)", subtitle: "", userInfo: userInfo)
            }
        }
        
        
    }
    
    /// 从 OCR 结果中获取 题目和答案
    func parseOCRResult(_ result: String) -> (question: String, answers: [String]) {

        var question = String()
        var answers: [String] = []
        
        if result.contains("?") {
            let components = result.components(separatedBy: "?").filter { !$0.isEmpty }
            question = components[0].replacingOccurrences(of: "\n", with: "")
            if components.count > 1 {
                let answerComponents = components[1].components(separatedBy: "\n").filter { !$0.isEmpty }
                for answer in answerComponents {
                   answers.append(answer)
                }
            }
        } else {
            var components = result.components(separatedBy: "\n").filter { !$0.isEmpty }
            if components.count >= 4 {
                for (index, com) in components.enumerated() {
                    if index < components.count - 3 {
                       question += com
                    } else {
                        answers.append(com)
                    }
                }
            } else if  components.count > 0 {
                question = components[0]
                components.remove(at: 0)
                answers = components
            }
        }
        question = question.trimmingCharacters(in: .decimalDigits)
        question = question.replacingOccurrences(of: ".", with: "")
        return (question, answers)
    }
    

}


