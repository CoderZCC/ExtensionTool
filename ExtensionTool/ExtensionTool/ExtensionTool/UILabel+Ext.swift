//
//  UILabel+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

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
