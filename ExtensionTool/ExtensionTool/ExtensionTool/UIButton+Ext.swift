//
//  UIButton+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var kUIButtonTimeIntervalKey: Int = 0
var kUIButtonFirstClickKey: Int = 1
var kUIButtonDelayingKey: Int = 2

extension UIButton {
    
    /// 按钮点击一次的时间间隔
    var k_timeSpan: CGFloat {
        
        set {
            
            objc_setAssociatedObject(self, &kUIButtonTimeIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if self.isKind(of: UIButton.self) {
                
                // 替换方法
                let originalSel = #selector(UIButton.sendAction(_:to:for:))
                let originalMethod = class_getInstanceMethod(UIButton.self, originalSel)!
                let encoding =  method_getTypeEncoding(originalMethod)
                
                let exchangeSel = #selector(UIButton.k_myMethod(_:to:for:))
                let exchangedMethod = class_getInstanceMethod(UIButton.self, exchangeSel)!
                let exchangeIMP = method_getImplementation(exchangedMethod)
                
                if class_addMethod(UIButton.self, exchangeSel, exchangeIMP, encoding) {
                    
                    class_replaceMethod(UIButton.self, originalSel, exchangeIMP, encoding)
                    
                } else {
                    
                    method_exchangeImplementations(originalMethod, exchangedMethod)
                }
            }
        }
        get { return (objc_getAssociatedObject(self, &kUIButtonTimeIntervalKey) as? CGFloat) ?? 0.0 }
    }
    
    /// 是否是第一次点击,是的话执行,下一次点击延迟
    fileprivate var k_isFirstClick: Bool {
        
        set {
            
            objc_setAssociatedObject(self, &kUIButtonFirstClickKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return (objc_getAssociatedObject(self, &kUIButtonFirstClickKey) as? Bool) ?? true }
    }
    /// 是否正在执行延迟操作
    fileprivate var k_isDelaying: Bool {
        
        set {
            
            objc_setAssociatedObject(self, &kUIButtonDelayingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return (objc_getAssociatedObject(self, &kUIButtonDelayingKey) as? Bool) ?? false }
    }
    
    @objc func k_myMethod(_ action: Selector, to: Any, for event: UIControlEvents) {
        
        if self.isKind(of: UIButton.self) {
            
            if self.k_isDelaying { return }
            if self.k_isFirstClick {
                
                self.k_myMethod(action, to: to, for: event)
                self.k_isFirstClick = false
                
            } else {
                
                self.k_isDelaying = true
                DispatchQueue.k_asyncAfterOnMain(dealyTime: Double(self.k_timeSpan)) { [unowned self] in
                    
                    self.k_isDelaying = false
                    self.k_myMethod(action, to: to, for: event)
                }
            }
            
        } else {
            
            self.k_myMethod(action, to: to, for: event)
        }
    }
}

var kUIButtonClickKey: Int = 0

extension UIButton {
    
    //MARK: UIButton添加点击事件
    /// UIButton添加点击事件
    ///
    /// - Parameters:
    ///   - events: 事件
    ///   - block: 回调
    func k_addTarget(events: UIControlEvents = .touchUpInside, block: @escaping()->Void) {
        
        objc_setAssociatedObject(self, &kUIButtonClickKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(k_btnAction), for: events)
    }
    @objc func k_btnAction() {
        
        if let block = objc_getAssociatedObject(self, &kUIButtonClickKey) as? ()->Void {
            
            block()
        }
    }
    
    //MARK: 设置特殊的按钮
    /// 设置特殊的按钮
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - title: 文字
    ///   - titlePosition: 文字位置
    ///   - spacing: 文字和图片间隔
    ///   - state: 按钮状态
    func k_setBtn(image: UIImage?, title: String, titlePosition: UIViewContentMode, spacing: CGFloat = 5.0, state: UIControlState = .normal) {
        
        self.imageView?.contentMode = .center
        self.setImage(image, for: state)
        
        self.positionLabelRespectToImage(title: title, position: titlePosition, spacing: spacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    fileprivate func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        var titleInsets: UIEdgeInsets!
        var imageInsets: UIEdgeInsets!
        
        switch (position){
        case .top:
            
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            
        case .bottom:
            
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            
        case .left:
            
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            
        case .right:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        default:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

