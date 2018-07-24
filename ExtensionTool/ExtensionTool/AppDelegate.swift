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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
        let nav = UINavigationController.init(rootViewController: vc)
        window?.rootViewController = nav

        return true
    }
}

