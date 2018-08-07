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
    func creatPlayerWith(cell: CellPlayerCell, url: String) {
        
        self.destoryPlayer()
        
        let playerView = VideoPlayerView.init(frame: cell.coverImgV.bounds)
        cell.coverImgV.addSubview(playerView)
        
        playerView.launchImageView.image = cell.coverImgV.image
        playerView.videoUrl = url
        //playerView.readyToPlay()
        playerView.isRunPlay = true
        
        self.currentPlayerView = playerView
        self.currentCell = cell
    }
    
    // 销毁
    func destoryPlayer() {
        
        self.currentPlayerView?.removeFromSuperview()
        self.currentPlayerView?.destoryPlayer()
        self.currentPlayerView = nil
    }
    
    @objc func tapAction() {
        
        let fatherView = self.currentCell!.coverImgV!
        fatherView.addSubview(self.currentPlayerView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            self.currentPlayerView?.frame = fatherView.bounds
            
        }) { (isOK) in
            
            // 添加点击手势,和平移手势
            
        }
    }
    
    @objc func panAction() {
        
        
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
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        return tap
    }()
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    
    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.tableView(self.tableView, didSelectRowAt: IndexPath.init(row: 0, section: 0))
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.destoryPlayer()
    }
}

extension CellPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.viewModel.dataList[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! CellPlayerCell
        let frame = cell.convert(cell.coverImgV.frame, to: self.view)
        CellDetailView.showDetail(currentImg: cell.coverImgV.image, originalFrame: frame)
        
//        // 防止一个单元格多次点击
//        if let currrentCell = self.currentCell, !currrentCell.isEqual(cell) {
//
//            self.creatPlayerWith(cell: cell, url: model.videoUrl)
//
//        } else if self.currentCell == nil {
//
//            self.creatPlayerWith(cell: cell, url: model.videoUrl)
//
//        } else {
//
//            kWindow.addSubview(self.currentPlayerView!)
//            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
//
//                self.currentPlayerView?.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
//
//            }) { (isOK) in
//
//                // 添加点击手势,和平移手势
//                self.currentPlayerView?.addGestureRecognizer(self.tapGesture)
//            }
//        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.k_dequeueReusableCell(cls: CellPlayerCell.self, indexPath: indexPath) as! CellPlayerCell
        cell.model = self.viewModel.dataList[indexPath.row]
        
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

