//
//  UIKit+Localized.swift
//  SuperVolley
//
//  Created by Zebra on 2018/7/20.
//  Copyright © 2018年 Zebra. All rights reserved.
//

import UIKit

/*
 UIButton.initLocalized()
 UILabel.initLocalized()
 UITextField.initLocalized()
 UITextView.initLocalized()
 */
extension UILabel {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UILabel.self, #selector(setter: UILabel.text))
        let swizzledMethod = class_getInstanceMethod(UILabel.self, #selector(UILabel.mySetText(_:)))
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    @objc func mySetText( _ text: String) {

        mySetText(text.localized())
    }
}

extension UIButton {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UIButton.self, #selector(UIButton.setTitle(_:for:)))
        let changedmethod = class_getInstanceMethod(UIButton.self, #selector(mySetTitle(_:for:)))
        method_exchangeImplementations(originalMethod!, changedmethod!)
    }
    @objc func mySetTitle(_ text: String, for state: UIControlState) {
        
        mySetTitle(text.localized(), for: state)
    }
}

extension UITextField {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UITextField.self, #selector(setter: UITextField.text))
        let changedmethod = class_getInstanceMethod(UITextField.self, #selector(mySetText(_:)))
        method_exchangeImplementations(originalMethod!, changedmethod!)
    }
    @objc func mySetText( _ text: String) {
        
        mySetText(text.localized())
    }
}

extension UITextView {
    
    /// 实现国际化
    static func initLocalized() {
        
        let originalMethod = class_getInstanceMethod(UITextField.self, #selector(setter: UITextField.text))
        let changedmethod = class_getInstanceMethod(UITextField.self, #selector(mySetText(_:)))
        method_exchangeImplementations(originalMethod!, changedmethod!)
    }
    @objc func mySetText( _ text: String) {
        
        mySetText(text.localized())
    }
}


