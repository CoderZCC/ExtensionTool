//
//  CameraListViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/23.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

class CameraListViewController: UIViewController {

    /// 是否裁剪
    var isCrop: Bool!
    /// 数据源
    var dataList: [PHAsset]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupSubViews()
    }
    
    //MARK: 设置导航栏
    func setupNavigation() {
        
    }
    
    //MARK: 初始化子视图
    func setupSubViews() {
     
        self.view.addSubview(self.collectionView)
        //top
        DispatchQueue.main.async {
            
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.dataList.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    //MARK: 事件
    
    
    //MARK: 懒加载
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.k_registerCell(cls: CameraListCell.self)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        
        collectionView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        
        layout.itemSize = CGSize(width: (kWidth - 5.0 * 5.0) / 4.0, height: (kWidth - 5.0 * 5.0) / 4.0)
        
        return collectionView
    }()
    
    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\n====== \(self) 销毁了======\n")
    }
}

extension CameraListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CameraListCell
        
        let previewVC = CameraPreviewViewController()
        previewVC.dataList = self.dataList
        previewVC.thumbImg = cell.imgV.image
        previewVC.indexPath = indexPath
        previewVC.isCrop = self.isCrop
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.k_dequeueReusableCell(cls: CameraListCell.self, indexPath: indexPath) as! CameraListCell
        let asset = self.dataList[indexPath.row]
        cell.imgAsset = asset
        
        return cell
    }
}

class CameraListCell: UICollectionViewCell {
    
    var imgAsset: PHAsset? {
        
        willSet {
            
            let options = PHImageRequestOptions.init()
            options.resizeMode = .fast
            // PHImageManagerMaximumSize
            PHImageManager.default().requestImage(for: newValue!, targetSize: CGSize(width: kWidth, height: kWidth), contentMode: PHImageContentMode.default, options: options) { (img, dic) in
                
                self.imgV.image = img
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgV)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 缩略图
    lazy var imgV: UIImageView = {
        let imgV = UIImageView.init(frame: self.contentView.bounds)
        imgV.k_contenModel()
        
        return imgV
    }()
    
}

