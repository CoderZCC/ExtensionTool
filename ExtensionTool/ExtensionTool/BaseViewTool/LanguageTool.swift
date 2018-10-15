//
//  AppDelegate.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

enum LanguageType {
    case en, ch
}

private let kLocalLanguageKey: String = "kLocalLanguageKey"

class LanguageTool: NSObject {
    
    static let tool: LanguageTool = LanguageTool()
    
    /// 文件加载路径
    static var bundle: Bundle?
    /// 当前语言
    static var currentLanguage: LanguageType {
        
        return ((UserDefaults.standard.value(forKey: kLocalLanguageKey) as? String) ?? "en") == "en" ? (.en) : (.ch)
    }
    
    /// 初始化本地语言
    class func initUserLanguage() {
        
        UIButton.initLocalized()
        UILabel.initLocalized()
        UITextField.initLocalized()

        var currentLanguage = UserDefaults.standard.value(forKey: kLocalLanguageKey) as? String
        if currentLanguage == nil {
            
            currentLanguage = Locale.preferredLanguages.first ?? "en"
            currentLanguage = currentLanguage!.hasPrefix("zh") ? ("zh-Hans") : ("en")
            UserDefaults.standard.setValue(currentLanguage, forKey: kLocalLanguageKey)
            UserDefaults.standard.synchronize()
        }
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")!
        LanguageTool.bundle = Bundle.init(path: path)
    }
    
    /// 设置语言类型
    ///
    /// - Parameter type: 类型
    class func setUserLanguage(_ type: LanguageType) {
        
        let typeStr: String = type == .en ? ("en") : ("zh-Hans")
        let currentLanguage: String = (UserDefaults.standard.value(forKey: kLocalLanguageKey) as? String) ?? "en"
        
        if currentLanguage == typeStr {
            
            debugPrint("语言切换为:\(typeStr == "en" ? ("英文") : ("中文"))")
            kWindow?.k_post(name: .userLanguageChanged)
            return
        }
        UserDefaults.standard.setValue(typeStr, forKey: kLocalLanguageKey)
        UserDefaults.standard.synchronize()
        
        let path = Bundle.main.path(forResource: typeStr, ofType: "lproj")!
        LanguageTool.bundle = Bundle.init(path: path)
        
        debugPrint("语言切换为:\(typeStr == "en" ? ("英文") : ("中文"))")
        kWindow?.k_post(name: .userLanguageChanged)
    }
}

extension String {
    
    var localiedStr: String {
        
        let changedStr: String = LanguageTool.bundle?.localizedString(forKey: "k\(self)", value: nil, table: "Localizable") ?? self
        if changedStr != "k\(self)" {
            
            return changedStr
        }
        return self
    }
}

extension UIButton {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UIButton.self, #selector(UIButton.setTitle(_:for:)))
        let changedmethod = class_getInstanceMethod(UIButton.self, #selector(mySetTitle(_:for:)))
        method_exchangeImplementations(originalMethod!, changedmethod!)
    }
    @objc func mySetTitle(_ text: String, for state: UIControl.State) {
        
        mySetTitle(text.localiedStr, for: state)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            
            self.k_addObserver(name: .userLanguageChanged) { [weak self] (note) in
                
                self?.setTitle(self?.currentTitle, for: self?.state ?? .normal)
            }
            
        } else {
            
            self.k_removeObserver(name: .userLanguageChanged)
        }
    }
}

extension UILabel {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UILabel.self, #selector(setter: UILabel.text))
        let swizzledMethod = class_getInstanceMethod(UILabel.self, #selector(UILabel.mySetText(_:)))
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    @objc func mySetText( _ text: String) {
        
        mySetText(text.localiedStr)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            
            self.k_addObserver(name: .userLanguageChanged) { [weak self] (note) in
                
                self?.text = self?.text
            }
            
        } else {
            
            self.k_removeObserver(name: .userLanguageChanged)
        }
    }
}

extension UITextField {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UITextField.self, #selector(setter: UITextField.placeholder))
        let changedmethod = class_getInstanceMethod(UITextField.self, #selector(mySetText(_:)))
        method_exchangeImplementations(originalMethod!, changedmethod!)
    }
    @objc func mySetText( _ text: String) {
        
        mySetText(text.localiedStr)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            
            self.k_addObserver(name: .userLanguageChanged) { [weak self] (note) in
                
                self?.placeholder = self?.placeholder
            }
            
        } else {
            
            self.k_removeObserver(name: .userLanguageChanged)
        }
    }
}
