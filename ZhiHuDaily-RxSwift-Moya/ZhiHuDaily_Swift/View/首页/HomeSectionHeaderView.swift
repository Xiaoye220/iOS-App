//
//  HomeSectionHeaderView.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 25/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeSectionHeaderView: UITableViewHeaderFooterView {
    
    var label: UILabel!
    
    var sectionTitle = String() {
        didSet { label.text = sectionTitle }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView() {
        contentView.backgroundColor = themeColor
        
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: Config.HomeController.headerViewFontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
