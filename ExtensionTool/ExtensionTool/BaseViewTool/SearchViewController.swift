//
//  SearchViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/14.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupSubViews()
        self.bindingData()
    }
    
    //MARK: 设置导航栏
    func setupNavigation() {
        
        self.navigationItem.titleView = self.searchView
    }
    
    //MARK: 初始化子视图
    func setupSubViews() {
        
    }
    
    //MARK: 绑定数据
    func bindingData() {
        
        
    }
    
    //MARK: 事件
    
    
    //MARK: 懒加载
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.k_width, height: self.view.k_height))
        tableView.k_hiddeLine()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    lazy var searchView: UIView = {
        let searchView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.k_width - 40.0 - 15.0, height: 28.0))
        
        let searchBar = UISearchBar.init(frame: searchView.bounds)
        searchBar.placeholder = "输入开始搜索"
        
        self.searchBar = searchBar
        searchView.addSubview(searchBar)

        return searchView
    }()

    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        self.searchBar = nil
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
