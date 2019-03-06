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
        
        self.setNavigation()
        self.setCommonData()

        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
        
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
    
    func setCommonData() {
        
        kWindow = self.window!
        kRootVC = self.window!.rootViewController
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
    
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let arr = identifier.components(separatedBy: ",")
        if (arr.first ?? "") == "x86_64" {
    
            kIsIphoneX = kHeight > 736.0
            
        } else {
            
            kIsIphoneX = (((arr.first ?? "") == "iPhone10") && ((arr.last ?? "") == "3" || (arr.last ?? "") == "6")) || (arr.first ?? "") >= "iPhone11"
        }
        
        if #available(iOS 11.0, *) {
            
            kIsIphoneX = self.window!.safeAreaInsets.bottom > 0.0
            
        } else {
            
            kIsIphoneX = false
        }
    }
}

