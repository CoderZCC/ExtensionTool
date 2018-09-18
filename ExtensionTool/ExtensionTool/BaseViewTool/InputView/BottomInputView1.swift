//
//  BottomInputView1.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 输入框(不可换行) + 按钮 
class BottomInputView1: UIView {

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
    class func initInputView(_ block: ((String)->Void)?) -> BottomInputView1 {
        let toolHeight: CGFloat = 49.0
        let tool = BottomInputView1.init(frame: CGRect(x: 0.0, y: kHeight - toolHeight - kBottomSpace, width: kWidth, height: toolHeight))
      
        tool.initSubViews()
        tool.registerNote()
        tool.textCallBack = block
        
        return tool
    }
    
    //MARK: -实现部分
    /// 点击文字回调
    private var textCallBack: ((String)->Void)?
    /// 输入框高度
    private let tFHeight: CGFloat = 35.0
    /// 输入框左侧间隔
    private let tFLeftMargin: CGFloat = 10.0
    /// 输入框右侧间隔
    private let tFRightMargin: CGFloat = 10.0
    /// 按钮宽度
    private let btnWidth: CGFloat = 75.0
    /// 按钮高度
    private let btnHeight: CGFloat = 35.0
    /// 按钮右侧间隔
    private let btnRightMargin: CGFloat = 10.0
    /// 占位文字
    private lazy var placeholderText: String = {
        
        return self.placeHolder ?? ""
    }()
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    private var note3: NSObjectProtocol!
    /// 发送按钮是否可用
    private var isBtnEnabled: Bool! {
        willSet {
            
            self.rightBtn.isEnabled = newValue
            self.rightBtn.backgroundColor = newValue ? (UIColor.blue) : (UIColor.darkGray)
        }
    }
    
    private func initSubViews() {
        
        self.addSubview(self.rightBtn)
        self.isBtnEnabled = false
        self.addSubview(self.textField)
    }
    
    /// 注册通知
    private func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            
            guard let weakSelf = self else { return }
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            weakSelf.transform = CGAffineTransform.init(translationX: 0.0, y: -height)
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            
            guard let weakSelf = self else { return }
            weakSelf.transform = CGAffineTransform.identity
        }
        
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            
            guard let weakSelf = self else { return }
            let tf = note.object as! UITextField
            if let text = tf.text, !text.isEmpty {
                weakSelf.isBtnEnabled = true
            } else {
                weakSelf.isBtnEnabled = false
            }
        }
    }
    /// 销毁通知
    private func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
        NotificationCenter.default.removeObserver(self.note3)
    }
    
    //MARK: -Lazy
    private lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect(x: self.tFLeftMargin, y: (self.bounds.height - self.tFHeight) / 2.0, width: kWidth - self.tFLeftMargin - self.tFRightMargin - self.btnWidth - self.btnRightMargin, height: self.tFHeight))
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var rightBtn: UIButton = { [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发送", for: .normal)
        btn.frame = CGRect(x: self.bounds.width - self.btnWidth - self.btnRightMargin, y: (self.bounds.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.backgroundColor = UIColor.blue
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in

            self.textCallBack?(self.textField.text!)
            self.textField.text = nil
        }
        
        return btn
    }()
    
    lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async { [unowned self] in
                
                self.textField.resignFirstResponder()
                UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                    
                    self.transform = CGAffineTransform.identity
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
    
}
