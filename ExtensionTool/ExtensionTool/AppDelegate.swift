//
//  AppDelegate.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
        let nav = UINavigationController.init(rootViewController: vc)
        
        window?.rootViewController = nav
        self.setNavigation()
        
        return true
    }
    
    /// 设置导航栏
    func setNavigation() {
        
        let navbar = UINavigationBar.appearance()
        // 设置标题文字颜色
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // 设置导航栏的背景颜色
        navbar.barTintColor = UIColor.k_colorWith(hexInt: 0xd22330)
        // 设置导航栏是否透明
        navbar.isTranslucent = false
        // 设置导航栏上按钮的颜色
        navbar.tintColor = UIColor.white
    }
}

