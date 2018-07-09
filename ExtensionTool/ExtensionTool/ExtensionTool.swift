//
//  ExtensionTool.swift
//  各种扩展
//
//  Created by 张崇超 on 2018/7/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

//MARK: 字符串相关
extension String {
    
    //MARK: 计算文字尺寸
    /// 计算文字尺寸
    ///
    /// - Parameters:
    ///   - size: 包含一个最大的值 CGSize(width: max, height: 20.0)
    ///   - font: 字体大小
    /// - Returns: 尺寸
    func k_textSize(size: CGSize, font: UIFont) -> CGSize {
        let nsStr = NSString.init(string: self)
        let rect = nsStr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
        
        return rect.size
    }
    
    //MARK: 裁剪字符串
    /// 裁剪字符串
    ///
    /// - Parameters:
    ///   - from: 开始位置 从0开始
    ///   - to: 结束位置 包含这个位置
    ///   var str: String = "0123456789"
    ///   str = str[1, 9]
    ///   输出: str = "123456789"
    /// - Returns: 新字符串
    func k_subText(from: Int = 0, to: Int) -> String {
        if from > to { return self }
        
        let startIndex = self.startIndex
        let fromIndex = self.index(startIndex, offsetBy: max(min(from, self.count - 1), 0))
        let toIndex = self.index(startIndex, offsetBy: min(max(0, to), self.count - 1))
        
        return String(self[fromIndex ... toIndex])
    }
    
    //MARK: 裁剪字符串, 使用: str[0, 10]
    /// 裁剪字符串, 使用: str[0, 10]
    ///
    /// - Parameters:
    ///   - from: 开始位置 从0开始
    ///   - to: 结束位置 包含这个位置
    subscript(_ from: Int, _ to: Int) -> String {
        
        return self.k_subText(from: from, to: to)
    }

    //MARK: 替换指定区域的文字
    /// 替换指定区域的文字
    ///
    /// - Parameters:
    ///   - range: 需要替换的文字范围
    ///   - replaceStr: 替换的文字
    /// - Returns: 新字符串
    func k_replaceStr(range: NSRange, replaceStr: String) -> String {
        var newStr: String = self
        if let range = Range.init(range, in: self) {
            
            newStr.replaceSubrange(range, with: replaceStr)
            
        } else {
            
            print("范围不正确")
        }
        return newStr
    }
    
    //MARK: 字符串转为日期
    /// 字符串转为日期
    ///
    /// - Parameters:
    ///   - dateStr: 字符串日期
    ///   - formatter: 字符串对应的日期格式
    ///   eg: dateStr: 2018 0908 11:20:23
    ///       formatter: yyyy MMdd HH:mm:ss
    /// - Returns: date
    func k_toDate(dateStr: String, formatter: String) -> Date {
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        var date = fat.date(from: dateStr)
        // 会少8个小时
        date != nil ? (date!.addTimeInterval(60.0 * 60.0 * 8.0)) : (print("时间格式不对应:k_toDate"))

        return date ?? Date()
    }
    
    //MARK: 时间戳转为字符串
    /// 时间戳转为字符串
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳 10位/13位
    ///   - output: 输出格式 默认:yyyy年MM月dd日 HH:mm:ss
    /// - Returns: 日期字符串
    static func k_timeStampToDateString(_ timeStamp: String, output: String = "yyyy年MM月dd日 HH:mm:ss") -> String {
        let newTimeStamp = timeStamp.count > 10 ? (timeStamp.k_subText(to: 9)): (timeStamp)
        let str = NSString.init(string: newTimeStamp)
        let doubleValue = str.doubleValue
        
        let fat = DateFormatter()
        fat.dateFormat = output
        let date = Date.init(timeIntervalSince1970: doubleValue)
        
        return fat.string(from: date)
    }
    
    //MARK: 比较两个格式相同的时间大小
    /// 比较两个格式相同的时间大小
    ///
    /// - Parameter otherTime: 时间
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    func k_compareToStr(_ otherTime: String, formatter: String) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        let t1 = self.k_toDate(dateStr: self, formatter: formatter)
        let t2 = self.k_toDate(dateStr: otherTime, formatter: formatter)
        let result: ComparisonResult = t1.compare(t2)
       
        return resultDic[result]!
    }
    
    //MARK: 指定时间转为特殊格式
    /// 指定时间转为特殊格式
    ///
    /// - Returns: 刚刚 / 几分钟前 / HH:mm / 昨天 HH:mm / MM-dd HH:mm / yyyy年MM-dd
    func k_dealTimeToShow(formatter: String) -> String {
        // 当前的时间
        let nowDate = Date()
        // 传入的时间
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        let selfDate = fat.date(from: self)!
        // 比当前时间还大
        if selfDate.k_compareToDate(nowDate) == 2 {
            
            return "未知时间"
        }
        let selfCom = selfDate.k_YMDHMS()
        let nowCom = nowDate.k_YMDHMS()

        if selfCom.year != nowCom.year {
            
            // 年不相等
            return selfDate.k_toDateStr("yyyy年MM-dd")
        }
        if nowCom.day! - selfCom.day! == 1 {
            
            // 日不相等,差一天
            return selfDate.k_toDateStr("昨天 HH:mm")
        }
        if selfCom.day! != nowCom.day! {
            
            // 日不相等,差一天以上
            return selfDate.k_toDateStr("MM-dd HH:mm")
        }
        if selfCom.hour! != nowCom.hour! {
            
            // 时不相等
            return selfDate.k_toDateStr("HH:mm")
        }
        if selfCom.minute! != nowCom.minute! {
            
            // 分不相等
            return "\(nowCom.minute! - selfCom.minute!)分钟前"
        }
        return "刚刚"
    }
    
}

//MARK: 日期相关
extension Date {
    
    //MARK: 指定日期的 年月日时分秒
    /// 指定日期的 年月日时分秒
    ///
    /// - Returns: DateComponents.year...
    func k_YMDHMS() -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let compent = calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: self)
        
        return compent
    }
    
    //MARK: 指定日期是 星期几
    /// 指定日期是 星期几
    ///
    /// - Returns: 星期一..日
    func k_weekDay() -> String {
        let dataDic: [Int: String] = [1: "星期天", 2: "星期一", 3: "星期二", 4: "星期三", 5: "星期四", 6: "星期五", 7: "星期六"]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let compent = calendar.dateComponents([.weekday], from: self)
        
        return dataDic[compent.weekday!]!
    }
    
    //MARK: 指定日期转为字符串(不用在Date + 8小时)
    /// 指定日期转为字符串(不用在Date + 8小时)
    ///
    /// - Parameter formatter: 格式 默认 yyyy-MM-dd HH:mm:ss
    /// - Returns: 时间字符串
    func k_toDateStr(_ formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fat = DateFormatter.init()
        fat.timeZone = TimeZone.current
        
        fat.dateFormat = formatter
        let str = fat.string(from: self)
        
        return str
    }
    
    //MARK: 日期比较大小
    /// 日期比较大小
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    func k_compareToDate(_ otherDate: Date) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        let result: ComparisonResult = self.compare(otherDate)

        return resultDic[result]!
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


