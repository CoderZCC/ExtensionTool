//
//  ExtensionTool.swift
//  各种扩展
//
//  Created by 张崇超 on 2018/7/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import UserNotifications

typealias k_noArgumentCallBack = (()->Void)?
typealias k_gestureCallBack = ((UIGestureRecognizer)->Void)?

extension NSObject {

    /// 当前活跃的导航栏
    var k_navigationVC: UINavigationController? {
        return self.navigationVC()
    }
    /// 当前活跃的控制器
    var k_currentVC: UIViewController {
        return self.currentVC()
    }
    /// 当前活跃的导航栏
    ///
    /// - Returns: 导航栏
    private func navigationVC(checkVC: UIViewController? = nil) -> UINavigationController? {
        
        let rootVC = checkVC == nil ? (kRootVC) : (checkVC)
        if let tabBarVC = rootVC as? UITabBarController {
            
            // 标签栏 + 导航栏
            return tabBarVC.selectedViewController as? UINavigationController
            
        } else if let navVC = rootVC as? UINavigationController {
            
            // 导航栏
            return navVC
            
        }
//        else if let sliderVC = rootVC as? SliderDrawerViewController {
//
//            // 侧滑
//            let main = sliderVC.mainVC
//            return self.navigationVC(checkVC: main!)
//        }
        return nil
    }
    
    /// 当前活跃的控制器
    ///
    /// - Returns: 控制器
    private func currentVC() -> UIViewController {
        
        return self.getCurrentVC()
    }
    private func getCurrentVC(checkVC: UIViewController? = nil) -> UIViewController {
        
        var rVC: UIViewController = checkVC == nil ? (kRootVC!) : (checkVC!)
        var currentVC: UIViewController!
       
        // 弹出试图判断
        if rVC.presentedViewController != nil {
            
            rVC = rVC.presentedViewController!
        }
        if let tabBarVC = rVC as? UITabBarController {
            
            currentVC = self.getCurrentVC(checkVC: tabBarVC.selectedViewController!)
        
        } else if let navVC = rVC as? UINavigationController {
            
            currentVC = self.getCurrentVC(checkVC: navVC.visibleViewController!)
        
        }
//        else if let sliderVC = rVC as? SliderDrawerViewController {
//
//            currentVC = self.getCurrentVC(checkVC: sliderVC.mainVC!)
//
//        }
        else {
            
            currentVC = rVC
        }
        return currentVC
    }
    
    //MARK: -发送本地推送
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

extension UILabel {
    
    //MARK: 指定区域文字颜色变化
    /// 指定区域文字颜色变化
    ///
    /// - Parameters:
    ///   - text: 文字内容
    ///   - range: 范围
    ///   - color: 字体颜色
    func k_setTextColor(text: String, range: NSRange, color: UIColor) {
        let attStr = NSMutableAttributedString.init(string: text)
        attStr.addAttributes([NSAttributedStringKey.foregroundColor : color], range: range)
        
        self.attributedText = attStr
    }
}

