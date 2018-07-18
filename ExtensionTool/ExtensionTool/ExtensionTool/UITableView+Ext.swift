//
//  UITableView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITableView {
    
    //MARK: 隐藏多余的线
    /// 隐藏多余的线
    func k_hiddeLine() {
        
        self.tableFooterView = UIView()
    }
    
    //MARK: 注册单元格 使用类名作为标记符
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    func k_registerCell(cls: AnyClass) {
        
        self.register(cls, forCellReuseIdentifier: NSStringFromClass(cls))
    }
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    func k_registerNibCell(cls: AnyClass) {
        
        self.register(UINib.init(nibName: NSStringFromClass(cls), bundle: nil), forCellReuseIdentifier: NSStringFromClass(cls))
    }
    //MARK: 获取注册的单元格
    /// 获取注册的单元格
    ///
    /// - Parameters:
    ///   - cls: 类名
    ///   - indexPath: indexPath
    func k_dequeueReusableCell(cls: AnyClass, indexPath: IndexPath) {
        
        self.dequeueReusableCell(withIdentifier: NSStringFromClass(cls), for: indexPath)
    }
    
}
