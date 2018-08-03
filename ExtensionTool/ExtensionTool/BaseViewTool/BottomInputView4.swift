//
//  BottomInputView4.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 输入框(不可换行) + 按钮 + 底部View
class BottomInputView4: UIView, UITextFieldDelegate {

    //MARK: -调用部分
    /// 占位文字
    var placeHolder: String? {
        willSet {
            self.textField.placeholder = newValue
        }
    }
    /// 创建试图
    ///
    /// - Parameter block: 点击文字回调
    class func initInputView(_ block: ((String)->Void)?) -> BottomInputView4 {
        let toolHeight: CGFloat = 49.0 + kBottomSpace
        let tool = BottomInputView4.init(frame: CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: toolHeight))
        tool.k_height += tool.extraHeight
        tool.originalFrame = CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: 49.0)
        
        tool.initSubViews()
        tool.registerNote()
        tool.textCallBack = block
        
        return tool
    }
    
    /// 注册通知
    func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            self.isClickEmoij = false
            
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            self.keyboradHeight = height
            self.transform = CGAffineTransform(translationX: 0.0, y: -self.keyboradHeight + kBottomSpace)
            self.emoijView.alpha = 0.0
            
            self.isEditting = true
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            if self.isClickEmoij { return }
            self.transform = CGAffineTransform.identity
            self.isEditting = false
        }
        
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: OperationQueue.main) { (note) in
            
            
        }
    }
    /// 销毁通知
    func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
        NotificationCenter.default.removeObserver(self.note3)
    }
    
    //MARK: -实现部分
    /// 输入框高度
    private let tFHeight: CGFloat = 35.0
    /// 点击文字回调
    private var textCallBack: ((String)->Void)?
    /// 输入框左侧间隔
    private let tFLeftMargin: CGFloat = 10.0
    /// 输入框右侧间隔
    private let tFRightMargin: CGFloat = 15.0
    /// 按钮宽度
    private let btnWidth: CGFloat = 35.0
    /// 按钮高度
    private let btnHeight: CGFloat = 35.0
    /// 按钮右侧间隔
    private let btnRightMargin: CGFloat = 15.0
    /// 原始位置
    private var originalFrame: CGRect!
    /// 标记换行
    private var lastHeight: CGFloat!
    /// 键盘高度
    private var keyboradHeight: CGFloat = 271.0
    /// 键盘是否弹出
    private var isEditting: Bool = false
    /// 额外的高度 键盘收起时.展示emoijView
    private var extraHeight: CGFloat = 200.0 + kBottomSpace
    /// 是否点击了emoij
    private var isClickEmoij: Bool = false
    /// 占位文字
    private lazy var placeholderText: String = {
        
        return self.placeHolder ?? ""
    }()
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    private var note3: NSObjectProtocol!
    
    /// 添加控件
    private func initSubViews() {
        
        self.addSubview(self.rightBtn)
        self.addSubview(self.textField)
        self.addSubview(self.emoijView)
    }
    
    //MARK: -Lazy
    private lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect(x: self.tFLeftMargin, y: (self.originalFrame.height - self.tFHeight) / 2.0, width: kWidth - self.tFLeftMargin - self.tFRightMargin - self.btnWidth - self.btnRightMargin, height: self.tFHeight))
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var rightBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "emoij"), for: .normal)
        btn.frame = CGRect(x: self.originalFrame.width - self.btnWidth - self.btnRightMargin, y: (self.originalFrame.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in
            
            if self.isClickEmoij { return }
            
            self.isClickEmoij = true
            if self.isEditting {
                
                self.textField.resignFirstResponder()
            }
            UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                
                self.emoijView.alpha = 1.0
                self.transform = CGAffineTransform(translationX: 0.0, y: -self.extraHeight + kBottomSpace)
            })
        }
        
        return btn
    }()
    
    lazy var emoijView: EmoijView = {
        let view = EmoijView.init(frame: CGRect(x: 0.0, y: self.textField.frame.maxY + self.textField.frame.origin.y, width: self.originalFrame.width, height: self.extraHeight))
        view.alpha = 0.0
        view.clickCallBack = { [unowned self] str in
            
            if str.contains("delete") {
                
                if let text = self.textField.text, !text.isEmpty {
                    
                    self.textField.text!.removeLast()
                }
                
            } else {
                
                self.textField.text!.append(str)
            }
        }
        
        return view
    }()
    
    lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async {[unowned self] in
                
                self.isClickEmoij = false
                self.textField.resignFirstResponder()
                
                UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                    
                    self.emoijView.alpha = 0.0
                    self.transform = CGAffineTransform.identity
                    self.isEditting = false
                })
            }
        })
        
        return view
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let newSuperview = newSuperview {
            
            // 添加蒙版
            newSuperview.insertSubview(self.insertView, belowSubview: self)
            
        } else {
            
            self.insertView.removeFromSuperview()
        }
    }
    
    deinit {
        
        self.destroyNote()
        print("###\(self)销毁了###\n")
    }
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text, !text.isEmpty {
            
            self.textCallBack?(textField.text!)
            textField.text = nil
            return false
        }
        return true
    }
}
