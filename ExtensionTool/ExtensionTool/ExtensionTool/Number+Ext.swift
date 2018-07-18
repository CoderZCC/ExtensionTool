//
//  Number+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension Int {
    
    /// 随机数 [0, to)
    ///
    /// - Parameters:
    ///   - to: 到n结束,不包含
    /// - Returns: [0, to)
    static func k_randomNum(to: Int) -> Int {

        return Int(arc4random() % UInt32(to < 0 ? (0) : (to)))
    }
    
    /// 转为字符串
    ///
    /// - Returns: 字符串
    func k_toString() -> String {
        return "\(self)"
    }
    
}

extension CGFloat {
    
    /// 转为字符串 保留两位小数
    ///
    /// - Returns: "2.00"
    func k_toCGFloatString() -> String {
        
        return String.init(format: "%.2f", self)
    }
    
    /// 转为整数字符串
    ///
    /// - Returns: "1"
    func k_toIntString() -> String {
        
        return String.init(format: "%ld", Int(self))
    }
    
}
