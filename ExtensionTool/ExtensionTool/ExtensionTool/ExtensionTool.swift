//
//  ExtensionTool.swift
//  各种扩展
//
//  Created by 张崇超 on 2018/7/6.
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

extension UIColor {
    
    /// 随机色
    class var k_randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    /// rbg颜色
    ///
    /// - Parameters:
    ///   - rgb: 一个大于1的数
    ///   - alpha: 透明度 0.0~1.0
    /// - Returns: 新颜色
    static func k_colorWith(rgb: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor.init(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: alpha)
    }
    
    /// rbg颜色
    ///
    /// - Parameters:
    ///   - r: 一个大于1的数
    ///   - g: 一个大于1的数
    ///   - b: 一个大于1的数
    ///   - alpha: 透明度 0.0~1.0
    /// - Returns: 新颜色
    static func k_colorWith(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
}
