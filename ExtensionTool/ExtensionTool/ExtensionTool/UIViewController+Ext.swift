//
//  UIViewController+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 设置导航栏透明度
    ///
    /// - Parameter alpha: 0.0~1.0
    func k_setNavBarAlpha(_ alpha: CGFloat) {
        
        let color = UIColor.k_colorWith(r: 30.0, g: 59.0, b: 145.0, alpha: alpha)
        self.k_navigationBar?.isTranslucent = true
        self.k_navigationBar?.setBackgroundImage(UIImage.k_imageWithColor(color), for: UIBarMetrics.default)
        self.k_navigationBar?.shadowImage = UIImage()
    }
    
    /// 设置导航栏透明
    func k_setNavBarTranslucent() {
        
//        let navBar = self.navigationController?.navigationBar
        let navBar = self.k_navigationBar
        navBar?.isTranslucent = true
        navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar?.shadowImage = UIImage()
    }
    
    /// 恢复导航栏透明
    func k_resetNavBarTranslucent() {
        
//        let navBar = self.navigationController?.navigationBar
        
        let navBar = self.k_navigationBar
        navBar?.isTranslucent = false
        navBar?.setBackgroundImage(nil, for: UIBarMetrics.default)
        navBar?.shadowImage = nil
    }
}

extension NSObject {
    
    /// 当前活跃的导航栏
    var k_navigationVC: UINavigationController? {
        return self.navigationVC()
    }
    /// 当前活跃的控制器
    var k_currentVC: UIViewController {
        return self.getCurrentVC()
    }
    /// 当前活跃的导航栏
    ///
    /// - Returns: 导航栏
    fileprivate func navigationVC(checkVC: UIViewController? = nil) -> UINavigationController? {
        
        let rootVC = checkVC == nil ? (kRootVC) : (checkVC)
        if let tabBarVC = rootVC as? UITabBarController {
            
            // 标签栏 + 导航栏
            return tabBarVC.selectedViewController as? UINavigationController
            
        } else if let navVC = rootVC as? UINavigationController {
            
            // 导航栏
            return navVC
        }
        return nil
    }
    
    /// 当前活跃的控制器
    ///
    /// - Returns: 控制器
    fileprivate func getCurrentVC(checkVC: UIViewController? = nil) -> UIViewController {
        
        var rVC: UIViewController = checkVC == nil ? (kRootVC) : (checkVC!)
        var currentVC: UIViewController!
        
        // 弹出试图判断
        if rVC.presentedViewController != nil {
            
            rVC = rVC.presentedViewController!
        }
        if let tabBarVC = rVC as? UITabBarController {
            
            currentVC = self.getCurrentVC(checkVC: tabBarVC.selectedViewController!)
            
        } else if let navVC = rVC as? UINavigationController {
            
            currentVC = self.getCurrentVC(checkVC: navVC.visibleViewController!)
            
        } else {
            
            currentVC = rVC
        }
        return currentVC
    }    
}

