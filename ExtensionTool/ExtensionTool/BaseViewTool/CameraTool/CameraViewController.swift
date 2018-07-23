//
//  CameraViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

let CameraRowHeight: CGFloat = 80.0

class CameraViewController: UIViewController {

    /// 回调
    var block: ((UIImage)->Void)?
    /// 是否裁剪
    var isCrop: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupSubViews()
        AuthorityTool.canUseAlbum { [unowned self] in
            
            self.cameraTool.getAllAlbums()
            self.tableView.reloadData()
        }
    }
    
    //MARK: 设置导航栏
    func setupNavigation() {
        
        self.title = "照片"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", clickCallBack: { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK: 初始化子视图
    func setupSubViews() {
        
        self.view.addSubview(self.tableView)
    }
    
    //MARK: 事件
    
    
    //MARK: 懒加载
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        tableView.tableFooterView = UIView()
        tableView.rowHeight = CameraRowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.k_registerCell(cls: CameraCell.self)
        
        return tableView
    }()
    
    lazy var cameraTool: CameraTool = {
        let tool = CameraTool()
        
        return tool
    }()
    
    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\n====== \(self) 销毁了======\n")
    }
}

extension CameraViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.cameraTool.dataList[indexPath.row]
        
        let listVC = CameraListViewController()
        listVC.title = model.title
        listVC.dataList = model.dataList
        listVC.isCrop = self.isCrop
        
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cameraTool.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.k_dequeueReusableCell(cls: CameraCell.self, indexPath: indexPath) as! CameraCell
        let model = self.cameraTool.dataList[indexPath.row]
        cell.model = model
        
        return cell
    }
}

class CameraCell: UITableViewCell {
    
    var model: AlbumModel! {
        
        willSet {
            
            self.textL.text = newValue.title + "(\(newValue.fetchResult!.count))"
            
            let options = PHImageRequestOptions.init()
            options.resizeMode = .fast
            let asset = newValue.fetchResult!.firstObject!
            // PHImageManagerMaximumSize
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: kWidth, height: kWidth), contentMode: PHImageContentMode.default, options: options) { (img, dic) in
                
                self.coverImg.image = img
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.coverImg)
        self.contentView.addSubview(self.textL)
        self.contentView.addSubview(self.arrowImgV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coverImg: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect.init(x: 10.0, y: 0.0, width: CameraRowHeight, height: CameraRowHeight))
        imgV.k_contenModel()

        return imgV
    }()
    lazy var textL: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: CameraRowHeight + 20.0, y: self.k_centerY + 10.0, width: kWidth, height: 20.0))
        label.textColor = UIColor.darkText
        
        return label
    }()
    lazy var arrowImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect.init(x: kWidth - 20.0 - 15.0, y: self.k_centerY + 10.0, width: 20.0, height: 20.0))
        imgV.image = #imageLiteral(resourceName: "arrow")
        
        return imgV
    }()
}

