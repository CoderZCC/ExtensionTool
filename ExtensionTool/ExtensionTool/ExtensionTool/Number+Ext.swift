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
}
