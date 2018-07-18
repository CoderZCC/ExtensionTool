//
//  NotificationCenter+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/18.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

enum NotificationName: Int {
    case loginSuccess, loginFail, loginError
}

var kNotificationCenterKey: Int = 0

extension NSObject {
    
    /// 通知对象,用于移除通知
    var k_observer: NSObjectProtocol {
        
        set {
            objc_setAssociatedObject(self, &kNotificationCenterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kNotificationCenterKey) as! NSObjectProtocol }
    }
    
    /// 发送通知
    ///
    /// - Parameters:
    ///   - noteName: 通知枚举
    ///   - object: 传递的对象
    ///   - userInfo: 传递的字典
    func k_post(name: NotificationName, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("\(name)"), object: object, userInfo: userInfo)
    }
    
    /// 接收通知
    ///
    /// - Parameters:
    ///   - forName: 通知枚举
    ///   - object: 传递的对象
    ///   - queue: 操作的线程 默认主线程
    ///   - using: 回调
    @discardableResult
    func k_addObserver(forName: NotificationName, object: Any? = nil, queue: OperationQueue? = OperationQueue.main, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        
        self.k_observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.init("\(forName)"), object: object, queue: queue, using: using)
        return self.k_observer
    }
    
    /// 移除通知
    ///
    /// - Parameters:
    ///   - name: 通知枚举
    ///   - object: 传递的对象
    func k_removeObserver(name: NotificationName, object: Any? = nil) {
        
        NotificationCenter.default.removeObserver(self.k_observer)
    }
}
