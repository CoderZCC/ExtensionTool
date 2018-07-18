//
//  UIBarButtonItem+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var kUIBarItemActionKey: Int = 0

extension UIBarButtonItem {
    
    /// 点击回调
    var k_barItemCallBack: (()->Void)? {
        
        set {
            
            objc_setAssociatedObject(self, &kUIBarItemActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, &kUIBarItemActionKey) as! (()->Void)?
        }
    }
    /// 添加点击事件回调
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - style: 类型 默认 plain
    ///   - clickCallBack: 点击回调
    /// - Returns: UIBarButtonItem
    convenience init(image: UIImage?, style: UIBarButtonItemStyle = .plain, clickCallBack: (()->Void)?) {
        
        self.init(image: image, style: style, target: nil, action: #selector(k_clickAction))
        self.k_barItemCallBack = clickCallBack
    }
    /// 添加点击事件回调
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - style: 类型 默认 plain
    ///   - clickCallBack: 点击回调
    /// - Returns: UIBarButtonItem
    convenience init(title: String?, style: UIBarButtonItemStyle = .plain, clickCallBack: (()->Void)?) {
        
        self.init(title: title, style: style, target: nil, action: #selector(k_clickAction))
        self.k_barItemCallBack = clickCallBack
    }
    /// 点击事件
    @objc func k_clickAction() {
        
        self.k_barItemCallBack?()
    }
}
