//
//  HomeStoryCell.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 25/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import RxSwift

class HomeStoryCell: UITableViewCell {
    
    var label: UILabel!
    var storyImageView: UIImageView!
    
    var imageDisposable: Disposable?
    var viewModel: HomeStoryCellViewModel?
    var story: Story? {
        didSet {
            imageDisposable?.dispose()
            viewModel = HomeStoryCellViewModel(story!)
            RxConfiguration()
        }
    }
    
    var hasSeen: Bool = false {
        didSet{ label.textColor = hasSeen ? UIColor.darkGray : UIColor.black }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    
    func setupView() {
        storyImageView = UIImageView()
        contentView.addSubview(storyImageView)
        storyImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(storyImageView.snp.height).multipliedBy(1.25)
        }
        storyImageView.contentMode = .scaleAspectFill
        storyImageView.clipsToBounds = true
        
        label = UILabel()
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalTo(storyImageView.snp.leading).offset(-15)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Config.HomeController.cellFontSize)
    }
    
    func RxConfiguration() {
        viewModel?.title
            .drive(onNext: { [weak self] title in
                self?.label.text = title
            })
            .disposed(by: disposeBag)
        
        imageDisposable = viewModel?.image
            .drive(onNext: { [weak self] image in
                self?.storyImageView.image = image
            })

        imageDisposable?.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
