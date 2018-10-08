//
//  StatusBar+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/10/8.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

//    plist文件 View controller-based status bar appearance Bool - NO
extension UIResponder {
    
    /// 设置电池条位置
    ///
    /// - Parameter orient: 位置
    func k_setStatusBarOrientation(_ orient: UIDeviceOrientation) {
        
        var orientation: UIInterfaceOrientation = .portrait
        if orient == .landscapeLeft || orient == .landscapeRight {
            
            orientation = orient == .landscapeLeft ? (.landscapeRight) : (.landscapeLeft)
        }
        UIApplication.shared.setStatusBarOrientation(orientation, animated: true)
    }
    
    /// 设置电池条显隐
    ///
    /// - Parameter isHidden: 显隐
    func k_setStatusBarHidden(_ isHidden: Bool) {
        
        UIApplication.shared.setStatusBarHidden(isHidden, with: UIStatusBarAnimation.fade)
    }
    
    /// 设置电池条风格
    ///
    /// - Parameter style: 风格
    func k_setStatusBarStyle(_ style: UIStatusBarStyle) {
        
        UIApplication.shared.setStatusBarStyle(style, animated: true)
    }
}

extension UINavigationController {
    
    open override var shouldAutorotate: Bool {
        
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
}

extension UITabBarController {

    open override var shouldAutorotate: Bool {

        return self.viewControllers?.first?.shouldAutorotate ?? false
    }
}
