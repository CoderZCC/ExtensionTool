//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var k_ImageViewClickActionKey: Int = 0
typealias k_noArgumentCallBack = (()->Void)?

extension UIImageView {
    
    //MARK: 设置为圆形控件
    /// 设置为圆形控件
    func k_setCircleImgV() {
        
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
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
    func k_addTarget(_ clickAction: k_noArgumentCallBack) {
        
        objc_setAssociatedObject(self, &k_ImageViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    /// 点击事件
    @objc func k_tapAction() {
        
        (objc_getAssociatedObject(self, &k_ImageViewClickActionKey) as! k_noArgumentCallBack)?()
    }
}

extension UIImage {
    
    //MARK: 裁剪方形图片为圆形
    /// 裁剪方形图片为圆形
    ///
    /// - Parameter backColor: 填充颜色,默认白色
    /// - Returns: 新图片
    func k_circleImage(backColor: UIColor = UIColor.white) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(), size: self.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 形状
        let circlePath = UIBezierPath.init(ovalIn: rect)
        circlePath.addClip()
        
        self.draw(in: rect)
        
        UIColor.darkGray.setStroke()
        circlePath.lineWidth = 1.0
        circlePath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
}
