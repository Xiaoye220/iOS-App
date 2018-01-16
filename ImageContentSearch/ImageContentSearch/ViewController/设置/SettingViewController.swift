//
//  SettingViewController.swift
//  ImageContentSearch
//
//  Created by YZF on 2018/1/12.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    enum Section: String {
        case game = "选择要进行答题的app"
        case duration = "答题助手开启的时间"
        case searchMode = "搜索方式"
    }
        
    var tableView: UITableView!
    
    var viewModel: SettingViewModel!
    
    let sections: [Section] = [.game, .duration, .searchMode]
    let contents: [[SettingType]] = [[Game.cddh, Game.zscr, Game.xgsp],
                                     [Duration._20minutes, Duration._30minutes, Duration._1hours],
                                     [SearchMode.questionOnly, SearchMode.questionWithAnswer, SearchMode.all]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: nvBarHeight + statusHeight, width: screenWidth, height: screenHeight - nvBarHeight - statusHeight), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contents[indexPath.section][indexPath.row]
        let section = sections[indexPath.section]
        
        switch section {
        case .game, .duration, .searchMode:
            let cell: CheckCell = content.tableView(tableView, cellForRowAt: indexPath)
            cell.textLabel?.text = content.title
            switch section {
            case .game:
                cell.isChecked = (content.title == MySetting.game.title)
            case .duration:
                cell.isChecked = (content.title == MySetting.duration.title)
            case .searchMode:
                cell.isChecked = (content.title == MySetting.searchMode.title)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contents[indexPath.section][indexPath.row]
        let section = sections[indexPath.section]
        switch section {
        case .game:
            viewModel.game.value = content as! Game
        case .duration:
            viewModel.duration.value = content as! Duration
        case .searchMode:
            viewModel.searchMode.value = content as! SearchMode
        }
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
