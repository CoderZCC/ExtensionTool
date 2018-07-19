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
   
    /// 注册推送
    func regitserAppRemoteAndLocalNote() {
        
        if #available(iOS 10.0, *) {
            
            self.initRemoteAndLocalNoteWithiOS10()

        } else {
            
            self.initRemoteAndLocalNoteWithiOS9()
        }
    }
    
    // 注册远程推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
    }
    // 注册远程推送失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        
    }
    
    // 检查通知状态
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        
    }
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

extension NSObject {
    
    //MARK: -发送本地推送
    /// 发送本地推送
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 文字
    ///   - dataDic: 字典
    func k_sendLocalNote(title: String, content: String, dataDic: [String: String]) {
        
        DispatchQueue.main.async {
            
            // 版本适配
            if #available(iOS 10.0, *) {
                
                let localNoteCenter = UNUserNotificationCenter.current()
                let noteContent = UNMutableNotificationContent.init()
                noteContent.title = title
                noteContent.body = content
                noteContent.sound = UNNotificationSound.default()
                
                noteContent.userInfo = dataDic
                
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest.init(identifier: "aaa", content: noteContent, trigger: trigger)
                
                localNoteCenter.add(request, withCompletionHandler: { (error) in
                    
                    print("推送错误信息:\(String(describing: error))")
                })
                
            } else {
                
                let note = UILocalNotification.init()
                // 触发时间
                note.fireDate = Date.init(timeIntervalSinceReferenceDate: 0.3)
                // 时区
                note.timeZone = NSTimeZone.default
                // 重复间隔
                note.repeatInterval = NSCalendar.Unit.init(rawValue: 0)
                // 推送数据
                note.userInfo = dataDic
                // 通知内容
                note.alertTitle = title
                note.alertBody = content
                
                note.soundName = UILocalNotificationDefaultSoundName
                
                let shared = UIApplication.shared
                shared.scheduleLocalNotification(note)
            }
        }
    }
}
