//
//  String+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

//MARK: 字符串相关
extension String {
    
    /// 是否为空, 全空格/empty
    ///
    /// - Returns: 是否
    func k_isEmpty() -> Bool {
        if self.isEmpty {
            
            return true
        }
        let set = CharacterSet.whitespacesAndNewlines
        let trimedStr = self.trimmingCharacters(in: set)
        
        return trimedStr.isEmpty
    }
    
    /// 转为URL
    ///
    /// - Returns: URL
    func k_toURL() -> URL? {
        if self.hasPrefix("http") {
            
            return URL(string: self)
        }
        
        return URL(fileURLWithPath: self)
    }
    
    //MARK: 计算文字尺寸
    /// 计算文字尺寸
    ///
    /// - Parameters:
    ///   - size: 包含一个最大的值 CGSize(width: max, height: 20.0)
    ///   - font: 字体大小
    /// - Returns: 尺寸
    func k_textSize(size: CGSize, font: UIFont) -> CGSize {
        let nsStr = NSString.init(string: self)
        let rect = nsStr.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
        
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
    func k_toDate(formatter: String) -> Date {
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        var date = fat.date(from: self)
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
        let t1 = self.k_toDate(formatter: formatter)
        let t2 = otherTime.k_toDate(formatter: formatter)
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
            return selfDate.k_toDateStr("今天 HH:mm")
        }
        if selfCom.minute! != nowCom.minute! {
            
            // 分不相等
            return "\(nowCom.minute! - selfCom.minute!)分钟前"
        }
        return "刚刚"
    }
  
    //MARK: caches路径
    /// caches路径
    static var k_cachesPath: String {
        
        return NSHomeDirectory() + "/Library/Caches/"
    }
    
    //MARK: documents路径
    /// documents路径
    static var k_documentsPath: String {
        
        return NSHomeDirectory() + "/Documents/"
    }
    
    //MARK: tmp路径
    /// tmp路径
    static var k_tmpPath: String {
        
        return NSHomeDirectory() + "/tmp/"
    }
    
    //MARK: 转为Int
    /// 转为Int
    ///
    /// - Returns: Int
    func k_toInt() -> Int {

        return Int(self) ?? 0
    }
    
    //MARK: 转为转为CGFloat
    /// 转为CGFloat
    ///
    /// - Returns: CGFloat
    func k_toCGFloat() -> CGFloat {
        
        return CGFloat(Double(self) ?? 0.0)
    }
}

extension String {
    
    /// 是否包含Emoij
    ///
    /// - Returns: 是/否
    func k_containsEmoij() -> Bool {
        
        if let regex = try? NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive) {
            
            let arr = regex.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count))
            
            return arr.isEmpty
        }
        return false
    }
    
    /// 移除字符串中的Emoij
    ///
    /// - Returns: 新字符串
    func k_deleteEmoij() -> String {
        
        if self.k_containsEmoij() {
            
            let regex = try! NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
            let changeStr = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count), withTemplate: "")
            
            return changeStr
        }
        return self
    }
    
    /// 是否符合邮箱规则
    var k_isEmail: Bool {
        
        return self.k_isCorrect("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    /// 是否符合手机号码规则
    var k_isPhoneNUm: Bool {
        
        if self.count != 11 {
            return false
        }
        return self.k_isCorrect("^[1][358][0-9]{9}$")
    }
    
    /// 是否符合身份证规则
    var k_isIdCard: Bool {
        
        return self.k_isCorrect("^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    
    /// 格式是否正确
    private func k_isCorrect(_ str: String) -> Bool {
        let correct = NSPredicate(format: "SELF MATCHES %@", str)
       
        return correct.evaluate(with: self)
    }
}

extension String {
    
    /// json串转为任意类型
    ///
    /// - Returns: 任意类型
    func k_jsonStrToObject() -> Any? {
        
        if self.k_isEmpty() {
            
            return nil
        }
        if let data = self.data(using: String.Encoding.utf8) {
            
            let arr = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            return arr
        }
        return nil
    }
}

extension Collection {
    
    /// 转为Json字符串
    ///
    /// - Returns: json串
    func k_toJsonStr() -> String? {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            
            return String.init(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}
