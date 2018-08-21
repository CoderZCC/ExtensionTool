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
    var k_observer: [String: NSObjectProtocol]? {

        set {
            objc_setAssociatedObject(self, &kNotificationCenterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kNotificationCenterKey) as? [String: NSObjectProtocol] }
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

        var noteDic: [String: NSObjectProtocol] = self.k_observer ?? [:]
        let value = NotificationCenter.default.addObserver(forName: NSNotification.Name.init("\(forName)"), object: object, queue: queue, using: using)
        noteDic["\(forName)"] = value
        self.k_observer = noteDic

        return value
    }

    /// 移除通知
    ///
    /// - Parameters:
    ///   - name: 通知枚举
    ///   - object: 传递的对象
    func k_removeObserver(name: NotificationName? = nil, object: Any? = nil) {

        self.k_selfRemoveMethod(name: name == nil ? (nil) : ("\(name!)"), object: object)
    }

    /// 接收系统通知
    ///
    /// - Parameters:
    ///   - forName: 通知枚举
    ///   - object: 传递的对象
    ///   - queue: 操作的线程 默认主线程
    ///   - using: 回调
    @discardableResult
    func k_addObserverSystem(forName: NSNotification.Name, object: Any? = nil, queue: OperationQueue? = OperationQueue.main, using: @escaping (Notification) -> Void) -> NSObjectProtocol {

        var noteDic: [String: NSObjectProtocol] = self.k_observer ?? [:]
        let value = NotificationCenter.default.addObserver(forName: forName, object: object, queue: queue, using: using)
        noteDic["\(forName)"] = value
        self.k_observer = noteDic

        return value
    }
    /// 移除系统通知
    ///
    /// - Parameters:
    ///   - name: 通知枚举
    ///   - object: 传递的对象
    func k_removeObserverSystem(name: NSNotification.Name? = nil, object: Any? = nil) {

        self.k_selfRemoveMethod(name: name == nil ? (nil) : ("\(name!)"), object: object)
    }

    /// 移除通知
    private func k_selfRemoveMethod(name: String? = nil, object: Any? = nil) {

        if let name = name {

            if let value = (self.k_observer ?? [:])["\(name)"] {

                NotificationCenter.default.removeObserver(value, name: .init(name), object: object)
            }
            self.k_observer?.removeValue(forKey: name)

        } else {

            for value in (self.k_observer ?? [:]).values {
                
                NotificationCenter.default.removeObserver(value)
            }
            self.k_observer = nil
        }
    }
}
