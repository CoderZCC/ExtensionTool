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

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addSubview(self.videoView)
        self.view.addSubview(self.tableView)
        self.tableView.k_y = self.videoView.frame.maxY
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var videoView: VideoView = {
        let view = VideoView.init(frame: CGRect(x: 0.0, y: 0.0, width: kWidth, height: 300.0))
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.k_registerCell(cls: UITableViewCell.self)
        
        return tableView
    }()

}
extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.k_dequeueReusableCell(cls: UITableViewCell.self, indexPath: indexPath)
        cell.backgroundColor = UIColor.k_randomColor
        
        return cell
    }
}
