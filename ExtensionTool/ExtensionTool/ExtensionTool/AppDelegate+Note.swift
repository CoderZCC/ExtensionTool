//
//  AppDelegate+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate {
   
    /// 注册本地推送
    func regitserAppLocalNote() {
        
        // 注册通知
        if #available(iOS 10.0, *) {
            
            self.initRemoteAndLocalNoteWithiOS10()

        } else {
            
            self.initRemoteAndLocalNoteWithiOS9()
        }
    }
    
    /*
    // 注册远程推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
    }
    // 注册远程推送失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        
    }
    
    // 检查通知状态
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        
    }
     */
}

//MARK: -iOS10.0之后
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 注册远程和本地推送到系统
    func initRemoteAndLocalNoteWithiOS10() {
        
        if #available(iOS 10.0, *) {
            
            let noteCenter = UNUserNotificationCenter.current()
            noteCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            noteCenter.requestAuthorization(options: types) { (flag, error) in
                
                if let _ = error {
                    
                    print("iOS 10 request notification fail")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // app即将弹出弹窗
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    // 用户点击通知时调用
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

//MARK: -iOS 10.0之前 iOS8.0之前
extension AppDelegate {
    
    func initRemoteAndLocalNoteWithiOS9() {
        
        let shared = UIApplication.shared
        let setting = UIUserNotificationSettings.init(types: [.alert, .sound], categories: nil)
        shared.registerUserNotificationSettings(setting)
        shared.registerForRemoteNotifications()
    }
    
    // app在前台收到本地通知调用或者在home情况下点击通知进入前台调用
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    // 接收到远程推送
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("接收到远程推送111")
    }
    
    // 接收到远程推送
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("接收到远程推送222")
        completionHandler(.newData)
    }
}
