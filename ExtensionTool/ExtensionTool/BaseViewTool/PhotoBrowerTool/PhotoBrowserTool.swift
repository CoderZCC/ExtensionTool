//
//  PhotoBrowserTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class PhotoBrowserTool: UIView {
    
    static var placeholderImg: UIImage?
    
    /// 展示大图
    ///
    /// - Parameters:
    ///   - containerView: 父视图(集合视图/表视图/UIView/nil)
    ///   - imgArr: 图片数组
    ///   - currentIndex: 当前下标
    ///   - currentImg: 当前图片
    class func showImage(containerView: UIView?, imgArr: [String], currentIndex: Int, currentImg: UIImage?) {
        
        let tool = PhotoBrowserTool(frame: UIScreen.main.bounds)
        
        tool.containerView = containerView
        tool.imgArr = imgArr
        tool.currentIndex = currentIndex
        tool.currentImg = currentImg

        tool.showFirstImage()
        
        if #available(iOS 11.0, *) {
            tool.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        kWindow.addSubview(tool)
    }
    
    /// 容器
    private var containerView: UIView?
    /// 下标
    private var currentIndex: Int!
    /// 数组
    private var imgArr: [String]!
    /// 图片
    private var currentImg: UIImage?
    /// 是否执行动画
    private var isAnimating: Bool = false
    
    /// 展示
    private func showFirstImage() {
        
        if self.isAnimating { return }
        if let scrollView = self.containerView as? UIScrollView {
            
            self.isAnimating = true
            // 添加集合视图
            self.collectionView.isHidden = true
            self.addSubview(self.collectionView)
            // 滚动到指定区域
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            // 假的图片
            let falseImageView = UIImageView()
            falseImageView.contentMode = .scaleAspectFit
            falseImageView.frame = self.originalRectWith(scrollView)
            falseImageView.image = self.currentImg
            self.addSubview(falseImageView)
            
            UIView.animate(withDuration: 0.3, animations: {

                self.backgroundColor = UIColor.black
                falseImageView.center = self.center
                falseImageView.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)

            }) { (isOK) in

                self.isAnimating = false
                falseImageView.isHidden = true
                falseImageView.removeFromSuperview()
                self.collectionView.isHidden = false
            }
            
        } else {
            
            self.isAnimating = true
            self.addSubview(self.collectionView)
            // 滚动到指定区域
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            
            self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.25, animations: {
                
                self.backgroundColor = UIColor.black
                self.transform = CGAffineTransform.identity
                
            }) { (isOk) in
                
                self.isAnimating = false
            }
        }
    }
    
    /// 隐藏
    private func dismissView() {
        
        if self.isAnimating { return }
        if let scrollView = self.containerView as? UIScrollView {
            
            self.isAnimating = true
            self.collectionView.isHidden = true
            // 假的图片
            let height: CGFloat = (self.bounds.width / self.currentImg!.size.width) * self.currentImg!.size.height
            
            let falseImageView = UIImageView()
            falseImageView.clipsToBounds = true
            falseImageView.contentMode = .scaleAspectFill
            
            falseImageView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: height)
            falseImageView.center = self.center
            
            falseImageView.image = self.currentImg
            self.addSubview(falseImageView)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.0)
                falseImageView.frame = self.originalRectWith(scrollView)
                
            }) { (isOK) in
                
                self.isAnimating = false
                self.removeFromSuperview()
            }
            
        } else {
            
            self.isAnimating = true
            UIView.animate(withDuration: 0.25, animations: {
                
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.0)
                self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                
            }) { (isOk) in
                
                self.isAnimating = false
                self.removeFromSuperview()
            }
        }
    }
    
    /// 获取原始位置
    private func originalRectWith(_ scrollView: UIScrollView) -> CGRect {
        
        var rect: CGRect!
        if let col = scrollView as? UICollectionView {
            
            let cell = col.cellForItem(at: IndexPath(row: self.currentIndex, section: 0))!
            rect = self.containerView!.convert(cell.frame, to: self)
            
        } else if let tab = scrollView as? UITableView {
            
            let cell = tab.cellForRow(at: IndexPath(row: self.currentIndex, section: 0))!
            rect = self.containerView!.convert(cell.frame, to: self)
        }
        return rect
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height - 1.0)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoBrowerCell.self, forCellWithReuseIdentifier: "PhotoBrowerCell")
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = self.backgroundColor
        
        return collectionView
    }()

    deinit {
        print("##### \(self)销毁了 #####")
    }
}

extension PhotoBrowserTool: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imgArr ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowerCell", for: indexPath) as! PhotoBrowerCell
        cell.imageView.image = UIImage.init(named: self.imgArr[indexPath.row])
        cell.clickCallBack = { [unowned self] in
            
            self.dismissView()
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offSetY = scrollView.contentOffset.x
        let index = Int(offSetY / self.bounds.width)
        self.currentIndex = index
        //self.alertLabel.text = "\(index + 1)/\(self.dataList.count)"
        
        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as! PhotoBrowerCell
        self.currentImg = cell.imageView.image
    }    
}

