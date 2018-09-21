//
//  Badge+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/24.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    /// 系统角标
    ///
    /// - Parameters:
    ///   - index: 下标
    ///   - badgeNum: 角标数
    func k_setTabBarItem(at index: Int, badgeNum: Int) {
        
        let itemArr = self.tabBar.items ?? []
        if index > itemArr.count - 1 { return }
        
        let item = itemArr[index]
        item.badgeValue = "\(badgeNum)"
        if badgeNum < 0 {
            item.badgeValue = nil
        }
    }
    
    /// 展示
    ///
    /// - Parameter index: 下标
    func k_showBadgeAt(_ index: Int) {
        
        self.k_removeBadgeAt(index)
        
        let precentX = (CGFloat(index) + 0.6) / CGFloat((self.tabBar.items ?? []).count)
        let x = ceilf(Float(precentX * self.tabBar.frame.width))
        let y = ceilf(Float(0.1 * self.tabBar.frame.height))
        
        let redView = UIView(frame: CGRect(x: Double(x), y: Double(y), width: 10.0, height: 10.0))
        redView.tag = 101
        redView.backgroundColor = UIColor.red
        redView.layer.cornerRadius = 5.0
        redView.clipsToBounds = true
        
        self.tabBar.addSubview(redView)
    }
    
    /// 隐藏
    ///
    /// - Parameter index: 下标
    func k_hiddenBadgeAt(_ index: Int) {
        
        let redView = self.tabBar.viewWithTag(101)
        redView?.isHidden = true
        self.k_removeBadgeAt(index)
    }
    
    /// 移除
    ///
    /// - Parameter index: 下标
    func k_removeBadgeAt(_ index: Int) {
        
        var redView = self.tabBar.viewWithTag(101)
        redView?.removeFromSuperview()
        redView = nil
    }
    
}

var kUIViewBadgeKey: Int = 0
extension UIView {
    
    /// 角标
    var k_bagdeFrame: CGRect {
        
        set {
            
            (self.viewWithTag(101) as? BadgeView)?.frame = newValue
        }
        get {return CGRect.zero }
    }
    /// 角标
    var k_badgeNum: Int? {
        
        set {
            
            if (newValue ?? 0) <= 0 {
                
                self.k_hiddenBadge()
                return
            }

            var badgeView: BadgeView!
            if let subView = self.viewWithTag(101) as? BadgeView {
                
                badgeView = subView

            } else {
                
                badgeView = BadgeView.instanced
                badgeView.tag = 101
                self.addSubview(badgeView)
                self.bringSubviewToFront(badgeView)
                
                badgeView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.3, animations: {
                    
                    badgeView.transform = CGAffineTransform.identity
                })
            }
            badgeView.badgeNum = newValue ?? 0
            
            let width: CGFloat = badgeView.frame.width
            let height: CGFloat = badgeView.frame.height
            badgeView.frame = CGRect.init(x: self.frame.width - width / 2.0, y: -height + height / 2.0, width: width, height: height)
            
            objc_setAssociatedObject(self, &kUIViewBadgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kUIViewBadgeKey) as? Int }
    }
    
    /// 隐藏badge
    func k_hiddenBadge() {
        
        var subView = self.viewWithTag(101) as? BadgeView
        if subView == nil { return }
        UIView.animate(withDuration: 0.3, animations: {
            
            subView?.badgeNum = 0
            subView?.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            
        }) { (isOK) in
            
            subView?.removeFromSuperview()
            subView = nil
        }
    }
}


class BadgeView: UILabel {
    
    static var instanced: BadgeView = BadgeView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
    
    var badgeNum: Int? {
        
        willSet {
            
            guard let num = newValue else { return }
            self.text = "\(num)"
            if num > 99 {
                
                self.text = "99+"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.backgroundColor = UIColor.red
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 10.0)
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
