//
//  CellPlayerViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellPlayerViewController: BaseViewController {

    var currentPlayerView: VideoPlayerView?
    var currentCell: CellPlayerCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.bindingData()
        self.setupSubViews()
    }
    
    //MARK: 设置导航栏
    func setupNavigation() {
        
    }
    
    //MARK: 初始化子视图
    func setupSubViews() {
     
        self.view.addSubview(self.tableView)
        self.viewModel.getData()
    }
    
    //MARK: 绑定数据
    func bindingData() {
        
        self.viewModel.reloadDataCallBack = { [unowned self] in
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: 事件
    /// 创建播放器
    func creatPlayerWith(cell: CellPlayerCell, url: String) {
        
        self.destoryPlayer()
        
        let playerView = VideoPlayerView.init(frame: cell.coverImgV.bounds)
        cell.coverImgV.addSubview(playerView)
        
        playerView.launchImageView.image = cell.coverImgV.image
        playerView.videoUrl = url
        playerView.isRunPlay = true
        playerView.readyToPlay()

        self.currentPlayerView = playerView
        self.currentCell = cell
    }
    
    /// 销毁
    func destoryPlayer() {
        
        self.currentPlayerView?.removeFromSuperview()
        self.currentPlayerView?.destoryPlayer()
        self.currentPlayerView = nil
    }
   
    /// 播放或全屏播放
    func playOrMoveToFullScreen(_ indexPath: IndexPath) {
        
        let model = self.viewModel.dataList[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! CellPlayerCell
        
        if !(self.currentCell ?? UITableViewCell()).isEqual(cell) {
            
            // 创建播放器
            self.creatPlayerWith(cell: cell, url: model.videoUrl)
            
        } else {
            
            // 全屏播放器
            let frame = cell.convert(cell.coverImgV.frame, to: self.view)
            CellDetailView.showDetail(baseView: cell.coverImgV, playerView: self.currentPlayerView!, originalFrame: frame)
        }
    }
    
    //MARK: 懒加载
    lazy var viewModel: CellPlayerViewModel = {
        
        return CellPlayerViewModel()
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.k_width, height: self.view.k_height))
        tableView.tableFooterView = UIView()
        tableView.rowHeight = self.view.k_height - kNavBarHeight
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.k_registerNibCell(cls: CellPlayerCell.self)
        
        return tableView
    }()
   
    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playOrMoveToFullScreen(IndexPath.init(row: 0, section: 0))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.destoryPlayer()
    }
}

extension CellPlayerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.k_dequeueReusableCell(cls: CellPlayerCell.self, indexPath: indexPath) as! CellPlayerCell
        cell.model = self.viewModel.dataList[indexPath.row]
        
        cell.coverImgV.k_addTarget { [unowned self] (tap) in
            
            self.playOrMoveToFullScreen(indexPath)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y + kNavBarHeight
        print(offsetY)
        
        for subCells in self.tableView.visibleCells {
            
            let cell = subCells as! CellPlayerCell
            print(cell)
        }
        print("结束减速")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("开始拖动")
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
}

