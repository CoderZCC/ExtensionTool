//
//  NotificationCenter+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/18.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

enum NotificationName: String {
    
    case loginSuccess, loginFail, loginError
}

private var kNotificationActionKey: Int = 0

extension NSObject {
    
    /// 别名
    typealias kNoteActionBlock = (Notification)->Void
    /// 存储一个对象的多个通知事件
    private var kNoteActionDic: [String: kNoteActionBlock]? {
        set {
            
            objc_setAssociatedObject(self, &kNotificationActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kNotificationActionKey) as? [String: kNoteActionBlock] }
    }
    
    /// 为当前对象注册系统通知
    ///
    /// - Parameters:
    ///   - name: NSNotification.Name
    ///   - object: object
    ///   - block: 事件回调
    func k_addObserverSystem(name: NSNotification.Name, object: Any? = nil, block:  @escaping kNoteActionBlock) {
        
        var dic: [String: kNoteActionBlock] = self.kNoteActionDic ?? [:]
        dic[name.rawValue] = block
        self.kNoteActionDic = dic
        
        NotificationCenter.default.addObserver(self, selector: #selector(k_noteAction), name: name, object: nil)
    }
    
    /// 移除当前对象的系统注册 name为nil 移除当前对象 所有的监听
    ///
    /// - Parameter name: NSNotification.Name
    func k_removeObserverSystem(name: NSNotification.Name? = nil) {
        
        if let name = name {

            NotificationCenter.default.removeObserver(self, name: name, object: nil)
            self.kNoteActionDic?.removeValue(forKey: name.rawValue)
            
            if (self.kNoteActionDic ?? [:]).isEmpty {
                
                self.kNoteActionDic = nil
            }
            
        } else {
            
            self.k_removeObserver()
        }
    }
    
    /// 发送通知
    ///
    /// - Parameters:
    ///   - name: NotificationName
    ///   - object: object
    ///   - userInfo: userInfo
    func k_post(name: NotificationName, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(name.rawValue), object: object, userInfo: userInfo)
    }
    
    /// 为当前对象注册自定义通知
    ///
    /// - Parameters:
    ///   - name: NotificationName
    ///   - object: object
    ///   - block: 事件回调
    func k_addObserver(name: NotificationName, object: Any? = nil, block: @escaping kNoteActionBlock) {
        
        var dic: [String: kNoteActionBlock] = self.kNoteActionDic ?? [:]
        dic[name.rawValue] = block
        self.kNoteActionDic = dic
        
        NotificationCenter.default.addObserver(self, selector: #selector(k_noteAction), name: NSNotification.Name.init(name.rawValue), object: object)
    }
    
    /// 移除当前对象的注册 name为nil 移除当前对象 所有的监听
    ///
    /// - Parameter name: NotificationName
    func k_removeObserver(name: NotificationName? = nil) {
        
        if let name = name {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(name.rawValue), object: nil)
            self.kNoteActionDic?.removeValue(forKey: name.rawValue)
            
            if (self.kNoteActionDic ?? [:]).isEmpty {
                
                self.kNoteActionDic = nil
            }
            
        } else {
            
            NotificationCenter.default.removeObserver(self)
            self.kNoteActionDic?.removeAll()
            self.kNoteActionDic = nil
        }
    }
    
    // 通知事件
    @objc private func k_noteAction(note: Notification) {
        
        let dic: [String: kNoteActionBlock] = self.kNoteActionDic ?? [:]
        dic[note.name.rawValue]?(note)
    }
}
