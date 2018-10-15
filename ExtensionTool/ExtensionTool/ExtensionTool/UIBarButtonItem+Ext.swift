//
//  UIBarButtonItem+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit


enum kUIBarItemPositionType {
    case left, right
}

var kUIViewControllerLeftTitleKey: Int = 0
var kUIViewControllerRightTitleKey: Int = 1

extension UIViewController {
    
    /// 设置文字按钮
    ///
    /// - Parameters:
    ///   - position: 左右按钮
    ///   - title: 文字
    ///   - style: 类型
    ///   - block: 回调
    func k_navigationItem(position: kUIBarItemPositionType = .right, title: String, style: UIBarButtonItem.Style = .plain, block: (()->Void)?)  {
        
        if position == .right {
            
            objc_setAssociatedObject(self, &kUIViewControllerRightTitleKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.k_navigationItem?.rightBarButtonItem = nil
            self.k_navigationItem?.rightBarButtonItem = UIBarButtonItem.init(title: title, style: style, target: self, action: #selector(k_rightItemAction))
            
        } else {
            
            objc_setAssociatedObject(self, &kUIViewControllerLeftTitleKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.k_navigationItem?.leftBarButtonItem = nil
            self.k_navigationItem?.leftBarButtonItem = UIBarButtonItem.init(title: title, style: style, target: self, action: #selector(k_leftItemAction))
        }
    }
    
    @objc private func k_leftItemAction() {
        
        let block = objc_getAssociatedObject(self, &kUIViewControllerLeftTitleKey) as? (()->Void)
        block?()
    }
    
    @objc private func k_rightItemAction() {
        
        let block = objc_getAssociatedObject(self, &kUIViewControllerRightTitleKey) as? (()->Void)
        block?()
    }
}

var kUIViewControllerLeftImageKey: Int = 2
var kUIViewControllerRightImageKey: Int = 3

extension UIViewController {
    
    /// 设置图片按钮
    ///
    /// - Parameters:
    ///   - position: 左右按钮
    ///   - image: 图片
    ///   - style: 类型
    ///   - block: 回调
    func k_navigationItemWith(position: kUIBarItemPositionType = .right, image: UIImage, style: UIBarButtonItem.Style = .plain, block: (()->Void)?)  {
        
        if position == .right {
            
            objc_setAssociatedObject(self, &kUIViewControllerRightImageKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.k_navigationItem?.rightBarButtonItem = UIBarButtonItem.init(image: image, style: style, target: self, action: #selector(k_rightImgItemAction))

        } else {
            
            objc_setAssociatedObject(self, &kUIViewControllerLeftImageKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.k_navigationItem?.rightBarButtonItem = UIBarButtonItem.init(image: image, style: style, target: self, action: #selector(k_leftImgItemAction))
        }
    }
    
    @objc private func k_leftImgItemAction() {
        
        let block = objc_getAssociatedObject(self, &kUIViewControllerLeftImageKey) as? (()->Void)
        block?()
    }
    
    @objc private func k_rightImgItemAction() {
        
        let block = objc_getAssociatedObject(self, &kUIViewControllerRightImageKey) as? (()->Void)
        block?()
    }
}

