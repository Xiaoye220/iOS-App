//
//  CheckCell.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit
import SnapKit

class CheckCell: UITableViewCell {

    var checkIcon: UILabel!
    
    var isChecked: Bool = false {
        didSet {
            checkIcon.isHidden = !isChecked
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        checkIcon = UILabel()
        addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        checkIcon.isHidden = true
        checkIcon.iconFont(size: 25, icon: Icon.check)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
