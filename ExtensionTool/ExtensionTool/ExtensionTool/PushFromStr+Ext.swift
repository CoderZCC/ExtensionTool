//
//  PushToFromStr+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/19.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension NSObject {
    
    /*
     使用方法
     lazy var pushVC: UIViewController = {
     let cls = self.k_getClassFrom("SecondViewController")!
     let pushVC: UIViewController = cls.init()
     pushVC.k_setValueToProperty(cls: cls, dataDic: ["name": "ZCC", "aaa": "aaa"])
     
     return pushVC
     }()
     */
    
    //MARK: 给属性赋值 属性需要 @objc修饰
    /// 给属性赋值 属性需要 @objc修饰
    /// @objc var name: String = ""
    /// eg: self.setValue("ZCC", forKey: "name")
    ///
    /// - Parameters:
    ///   - cls: 类
    ///   - dataDic: 数据字典
    func k_setValueToProperty(cls: UIViewController.Type, dataDic: [String: String]) {
        
        // 所有属性
        let allProperty: [String] = cls.K_propertyList()
        let keys = dataDic.keys
        for key in keys {
            
            // 是否有这个属性,防止崩溃
            if allProperty.contains(key) {
                
                self.setValue(dataDic[key], forKey: key)
            }
        }
    }
    
    //MARK: 字符串转为类
    /// 字符串转为类
    ///
    /// - Parameter clsName: 字符串名
    /// - Returns: class
    func k_getClassFrom(_ clsName: String) -> UIViewController.Type? {
        
        if let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            
            return NSClassFromString(nameSpace + "." + clsName) as? UIViewController.Type
        }
        return nil
    }
    
    //MARK: 获取类的所有属性 @objc修饰
    /// 获取类的所有属性 @objc修饰
    ///
    /// - Returns: [String]
    @discardableResult
    class func K_propertyList() -> [String] {
        
        var count: UInt32 = 0
        let prolist = class_copyPropertyList(self, &count)
        
        var arr: [String] = []
        for i in 0..<Int(count) {
            let pro = prolist?[i]
            // 获取 `属性` 的名称C语言字符串
            let proString = property_getName(pro!)
            // 转化成 String的字符串
            let proName = String(utf8String: proString)
            
            arr.append(proName ?? "")
        }
        print("获取类的所有属性:\(arr)")
        // 释放 C 语言的对象
        free(prolist)
        return arr
    }
}
