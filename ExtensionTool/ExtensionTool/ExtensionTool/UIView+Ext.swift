//
//  UIView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var k_UIViewClickActionKey: Int = 0

extension UIView {
    
    //MARK: 设置为圆形控件
    /// 设置为圆形控件
    func k_setCircleImgV() {
        
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
    }
    
    //MARK: 设置圆角
    /// 设置圆角
    ///
    /// - Parameter radius: 圆角数
    func k_setCornerRadius(_ radius: CGFloat) {
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /// 设置边框
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - width: 宽度
    func k_setBorder(color: UIColor, width: CGFloat) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    //MARK: 添加点击事件
    /// 添加点击事件
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - action: 事件
    func k_addTarget(_ target: Any, action: Selector) {
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    /// 添加点击事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addTarget(_ clickAction: k_gestureCallBack) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// 添加长按事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addLongPressTarget(_ clickAction: k_gestureCallBack) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// 点击事件
    @objc func k_tapAction(tap: UIGestureRecognizer) {
        
        (objc_getAssociatedObject(self, &k_UIViewClickActionKey) as! k_gestureCallBack)?(tap)
    }
    
    //MARK: 单击移除键盘
    /// 单击移除键盘
    func k_tapDismissKeyboard() {
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapDismissAction))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (note) in
            
            self.addGestureRecognizer(tap)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: OperationQueue.main) { (note) in
            
            self.removeGestureRecognizer(tap)
        }
    }
    @objc func tapDismissAction() {
        
        self.endEditing(true)
    }
    
}


