//
//  HYNavigationBar.swift
//  huayu
//
//  Created by huayu on 2018/6/6.
//  Copyright © 2018年 huayu. All rights reserved.
//

import UIKit

class MyNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for vvv in self.subviews {
            
            let className = NSStringFromClass(vvv.classForCoder)
            
            if className.elementsEqual("_UIBarBackground") {
                
                let height = UIApplication.shared.statusBarFrame.size.height
                var frame = self.bounds;
                frame.size.height = self.frame.size.height + height
                frame.origin.y = -height
                vvv.frame = frame
            }
        }
    }
}

private var kNavigationBarKey: Int = 0
private var kNavigationItemKey: Int = 1
private var kTitleKey: Int = 2

extension UIViewController: UIGestureRecognizerDelegate {
    
    /// 标题
    var k_title: String? {
        set {
        
            self.k_navigationItem?.title = newValue
            objc_setAssociatedObject(self, &kTitleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kTitleKey) as? String }
    }
    
    /// 自定义的导航条
    var k_navigationBar: UINavigationBar? {
        set {
            objc_setAssociatedObject(self, &kNavigationBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kNavigationBarKey) as? UINavigationBar }
    }
    /// 自定义的导航条Item 设置左右按钮 标题使用
    var k_navigationItem: UINavigationItem? {
        set {
            objc_setAssociatedObject(self, &kNavigationItemKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kNavigationItemKey) as? UINavigationItem }
    }
    
    /// 设置自定义的导航栏
    func k_setupMyNavBar() {
        
        guard let navController = self.navigationController else { return }
        // 隐藏系统的
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.isHidden = true
        // 创建自己的
        let navBar = MyNavigationBar.init()
        let size = UIApplication.shared.statusBarFrame.size
        
        let y = kVersion < 10.0 ? (0.0) : (size.height)
        let height: CGFloat = kVersion < 10.0 ? (64.0) : (44.0)
        navBar.frame = CGRect(x: 0, y: y, width: size.width, height: height)
        
        self.view.clipsToBounds = true
        self.view.addSubview(navBar)

        navBar.barTintColor = UIColor.k_colorWith(r: 30.0, g: 59.0, b: 145.0, alpha: 1.0)
        navBar.isTranslucent = false
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        
        navBar.pushItem(self.k_setupNavitionItem()!, animated: false)
        navController.interactivePopGestureRecognizer?.delegate = self
        self.k_navigationBar = navBar
    }
    
    /// 设置返回按钮为黑色
    func k_setNavBarBlackImg() {
        
        guard let navController = self.navigationController else { return }

        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "MyNavbarTool.bundle/navBack_black"), for: .normal)
        btn.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 44.0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -60.0, bottom: 0.0, right: 0.0)
        
        btn.k_addTarget {
            
            navController.popViewController(animated: true)
        }
        self.k_navigationItem?.setLeftBarButton(UIBarButtonItem(customView: btn), animated: true)
    }
    
    /// 隐藏导航栏
    func k_setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        
        if animated {
            
            UIView.animate(withDuration: 0.25) {
                
                self.k_navigationBar?.transform = hidden ? (CGAffineTransform(translationX: 0.0, y: -kNavBarHeight - 10.0)) : (CGAffineTransform.identity)
            }
            
        } else {
            
            self.k_navigationBar?.transform = hidden ? (CGAffineTransform(translationX: 0.0, y: -kNavBarHeight - 10.0)) : (CGAffineTransform.identity)
        }
    }
    
    /// 设置导航栏 默认白色返回按钮
    private func k_setupNavitionItem() -> UINavigationItem? {
        
        guard let navController = self.navigationController else { return nil }
        
        let navItem = UINavigationItem()
        self.k_navigationItem = navItem
        // 是否有返回按钮
        if navController.viewControllers.count > 1 {
            
            let btn = UIButton.init(type: UIButton.ButtonType.custom)
            btn.setImage(UIImage(named: "MyNavbarTool.bundle/navBack_white"), for: .normal)
            btn.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 44.0)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -60.0, bottom: 0.0, right: 0.0)
            btn.k_addTarget {
                
                navController.popViewController(animated: true)
            }
            
            let leftBtn = UIBarButtonItem(customView: btn)
            navItem.setLeftBarButton(leftBtn, animated: true)
        }
        
        return navItem
    }
    
    /// 是否允许手势
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let navController = self.navigationController else { return true }
        if gestureRecognizer.isEqual(navController.interactivePopGestureRecognizer) {
            
            //只有二级以及以下的页面允许手势返回
            return navController.viewControllers.count > 1
        }
        return true
    }
}
