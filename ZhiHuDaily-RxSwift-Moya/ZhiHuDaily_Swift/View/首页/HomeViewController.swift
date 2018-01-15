//
//  ViewController.swift
//  ZhiHuDaily_Swift
//
//  Created by YZF on 10/10/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class HomeViewController: BaseViewController {

    struct Indentifier {
        static let storyCell = "storyCell"
        static let headerView = "headerView"
    }
    
    var tableView: UITableView!
    var navigationView: NavigationView!
    var topStoryView: HomeTopStoryView!
    var statusBarView: UIView!

    var homeViewModel: HomeViewModel!
    
    var stories = Variable<[SectionModel<String, Story>]>([])

    var storiesHaveSeen: [Int] = (UserDefaultsUtils.value(forKey: .storiesHaveSeen) as? [Int]) ?? [] {
        didSet { UserDefaultsUtils.setValue(storiesHaveSeen, forKey: .storiesHaveSeen) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildView()
        RxConfiguration()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - BuildView
extension HomeViewController {
    func buildView() {
        buildTableView()
        buildTopStoryView()
        buildNavigation()
    }
    
    func buildNavigation() {
        navigationSetting.setNavigationBarClear()
            .titleColor(.white)
        
        navigationView = NavigationView()
        view.addSubview(navigationView)
        
        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        view.addSubview(statusBarView)
    }
    
    func buildTableView() {
        tableView = UITableView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.hideEmptyCells()
        tableView.rowHeight = Config.HomeController.rowHeight
        tableView.showsVerticalScrollIndicator = false
    }
    
    func buildTopStoryView() {
        topStoryView = HomeTopStoryView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: Config.HomeController.topStoryViewHeight), imageHeight: Config.HomeController.topStoryImageViewHeight, pageCount: Config.HomeController.topStoryPageCount)
        tableView.tableHeaderView = topStoryView
        topStoryView.delegate = self
    }
}

// MARK: - Rx_Configuration
extension HomeViewController {
    func RxConfiguration() {
        homeViewModel = HomeViewModel(tableView: tableView)
        navigationView.homeViewModel = homeViewModel
        topStoryView.homeViewModel = homeViewModel
        configurationTableView()
        configurationOthers()
    }
    
    func configurationTableView() {
        homeViewModel.tableViewContentOffsetY
            .drive(onNext: { [weak self] y in
                guard let welf = self else { return }
                let minOffsetY = Config.HomeController.topStoryViewHeight - Config.HomeController.topStoryImageViewHeight
                if y <= minOffsetY {
                    welf.tableView.setContentOffset(CGPoint(x: 0, y: minOffsetY), animated: false)
                }
                
                // 第二个section header拉至顶部时执行
                let topStoryHeight = Config.HomeController.topStoryViewHeight
                let rowHeight = Config.HomeController.rowHeight
                if y > (topStoryHeight + CGFloat(welf.tableView.numberOfRows(inSection: 0)) * rowHeight - statusBarHeight) &&
                    welf.navigationView.isHidden == false {
                    welf.navigationView.isHidden = true
                    welf.statusBarView.backgroundColor = themeColor
                    welf.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
                }
                if y < (topStoryHeight + CGFloat(welf.tableView.numberOfRows(inSection: 0)) * rowHeight - statusBarHeight) &&
                    welf.navigationView.isHidden == true {
                    welf.navigationView.isHidden = false
                    welf.statusBarView.backgroundColor = .clear
                    welf.tableView.contentInset = UIEdgeInsets.zero
                }
            })
            .disposed(by: disposeBag)
        
        // tableView 数据源
        do {
            tableView.register(HomeStoryCell.self, forCellReuseIdentifier: Indentifier.storyCell)
            tableView.register(HomeSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: Indentifier.headerView)
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Story>>(configureCell: {
                (ds, tv, indexPath, item) in
                let cell = tv.dequeueReusableCell(withIdentifier: Indentifier.storyCell) as! HomeStoryCell
                cell.story = item
                cell.hasSeen = self.storiesHaveSeen.contains(item.id)
                return cell
            })
            
            tableView.rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            stories.asDriver()
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

            homeViewModel.latestStories
                .subscribe(onNext: { [weak self] stories in
                    guard let welf = self else { return }
                    let sectionModel = SectionModel(model: stories.date!, items: stories.stories)
                    welf.stories.value.isEmpty ? (welf.stories.value.append(sectionModel)) : (welf.stories.value[0] = sectionModel)
                })
                .disposed(by: disposeBag)
            
            homeViewModel.beforeStories
                .asObservable()
                .filter { $0 != nil }
                .map { $0! }
                .subscribe(onNext: { [weak self] stories in
                    let sectionModel = SectionModel(model: stories.date!, items: stories.stories)
                    self?.stories.value.append(sectionModel)
                })
                .disposed(by: disposeBag)
        }
        
        // tableView didSetlected
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let welf = self else { return }
                let storyId = welf.stories.value[indexPath.section].items[indexPath.row].id
                welf.storiesHaveSeen.append(storyId!)
                let controller = StoryDetailViewController()
                controller.storyId = storyId
                controller.storyIds = welf.stories.value.map { $0.items.map { $0.id! } }
                welf.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func configurationOthers() {
        homeViewModel.beforeStoriesLoading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : Config.HomeController.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Indentifier.headerView) as? HomeSectionHeaderView
        sectionView?.sectionTitle = DateUtils.sectionHeaderDateTransform(stories.value[section].model)
        return sectionView
    }
}

extension HomeViewController: HomeTopStoryViewDelegate {
    
    func homeTopStoryViewDidTap(_ index: Int, storyId: Int) {
        let controller = StoryDetailViewController()
        controller.storyId = storyId
        controller.storyIds = self.stories.value.map { $0.items.map { $0.id! } }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


