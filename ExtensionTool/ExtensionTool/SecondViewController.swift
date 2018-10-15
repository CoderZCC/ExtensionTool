//
//  SecondViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class SecondViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.title_locailedStr = "第二个"
        self.view.insertSubview(self.tableView, belowSubview: self.k_navigationBar!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: -kTopSpace, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headView
        
        return tableView
    }()
    
    lazy var headView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: kWidth, height: 200.0))
        view.backgroundColor = UIColor.red
        
        return view
    }()
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let alpha = min(1.0, max(0.0, (offsetY) / kNavBarHeight))
        self.k_setNavBarAlpha(alpha)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(BaseViewController(), animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
