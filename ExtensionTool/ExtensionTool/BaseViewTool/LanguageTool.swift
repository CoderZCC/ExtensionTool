//
//  AppDelegate.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension String {
    
    /// 国际化文字
    func localized() -> String {
        
        return NSLocalizedString(self, comment: "")
        //return LanguageTool.getString(key: self)
    }
}

let UserLanguage = "UserLanguage"
let AppleLanguages = "AppleLanguages"

class LanguageTool: NSObject {
   
    static let shareInstance = LanguageTool()
    
    /// 偏好设置
    let def = UserDefaults.standard
    var bundle : Bundle?
    
    /// 获取key对应的字符串
    class func getString(key: String) -> String{
        let bundle = LanguageTool.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        
        return str ?? key
    }
    
    /// 初始化语言
    func initUserLanguage() {
        
        var string: String = def.value(forKey: UserLanguage) as? String ?? ""
        if string == "" {
            
            let languages = def.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                    def.set(current, forKey: UserLanguage)
                    def.synchronize()
                }
            }
        }
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
             path = Bundle.main.path(forResource:"en" , ofType: "lproj")
        }
        bundle = Bundle(path: path!)
    }
    
    /// 设置语言
    func setLanguage(langeuage: String) {
        
        let path = Bundle.main.path(forResource:langeuage , ofType: "lproj")
        bundle = Bundle(path: path!)
        def.set(langeuage, forKey: UserLanguage)
        def.synchronize()
    }
}
