//
//  UIViewController+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 设置导航栏透明
    func k_setNavBarTranslucent() {
        
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = true
        navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar?.shadowImage = UIImage()
    }
    
    /// 恢复导航栏透明
    func k_resetNavBarTranslucent() {
        
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.setBackgroundImage(nil, for: UIBarMetrics.default)
        navBar?.shadowImage = nil
    }
}
