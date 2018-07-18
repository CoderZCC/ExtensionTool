//
//  RemoteAndLocalPush+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/18.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import UserNotifications

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
