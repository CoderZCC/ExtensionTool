//
//  UIScrollView+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/18.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var UIScrollViewPlacholderTextKey: UInt = 0
var UIScrollViewPlacholderImgKey: UInt = 1

extension UIScrollView {
    
    /// 占位文字
    var k_placholderText: String? {
        get {
            return objc_getAssociatedObject(self, &UIScrollViewPlacholderTextKey
                ) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIScrollViewPlacholderTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 占位图
    var k_placholderImg: String? {
        get {
            return objc_getAssociatedObject(self, &UIScrollViewPlacholderImgKey
                ) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIScrollViewPlacholderImgKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 刷新数据 展示无数据占位图
    func k_reloadData(callBack: (()->Void)? = nil) {
        
        var sectionCount: Int = 0
        var rowCount: Int = 0
        if self.isKind(of: UITableView.self) {
            
            let tab = self as! UITableView
            tab.reloadData()
            
            sectionCount = tab.numberOfSections
            if sectionCount > 0 {
                rowCount = tab.numberOfRows(inSection: 0)
            }
            
        } else if self.isKind(of: UICollectionView.self) {
            
            let col = self as! UICollectionView
            col.reloadData()
            
            sectionCount = col.numberOfSections
            if sectionCount > 0 {
                rowCount = col.numberOfItems(inSection: 0)
            }
        }
        if sectionCount != 0 {
            
            // 有数据了
            if let view = self.viewWithTag(101) {
                
                view.removeFromSuperview()
            }
            return
        }
        if rowCount == 0 {
            
            // 无数据
            var view: PlaceHolderView!
            if let beforeView: PlaceHolderView = self.viewWithTag(101) as? PlaceHolderView {
                
                view = beforeView
                
            } else {
                
                view = PlaceHolderView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
                view.clickCallBack = callBack
                view.tag = 101
                
                self.addSubview(view)
            }
            view.textL.text = self.k_placholderText ?? "暂无数据哦~"
            view.imgV.image = UIImage.init(named: self.k_placholderImg ?? "noData")
            
        } else {
            
            // 有数据了
            if let view = self.viewWithTag(101) {
                
                view.removeFromSuperview()
            }
        }
    }
}

class PlaceHolderView: UIView {
    
    /// 点击回调
    var clickCallBack: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgV)
        self.addSubview(self.textL)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        
        self.clickCallBack?()
    }
    
    lazy var imgV: UIImageView = {
        let width: CGFloat = 80.0
        let imgV = UIImageView.init(frame: CGRect.init(x: (kWidth - width) / 2.0, y: self.textL.frame.minY - width, width: width, height: width))
        imgV.contentMode = .scaleAspectFit
        
        return imgV
    }()
    
    lazy var textL: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0.0, y: (self.frame.height - 40.0) / 2.0, width: self.frame.width, height: 40.0))
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
