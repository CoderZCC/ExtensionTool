//
//  BottomInputView2.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 输入框(可换行) + 按钮
class BottomInputView2: UIView {

    //MARK: -调用部分
    /// 占位文字
    var placeHolder: String? {
        willSet {
            self.textView.k_placeholder = newValue
        }
    }
    /// 创建试图
    ///
    /// - Parameter block: 点击文字回调
    class func initInputView(_ block: ((String)->Void)?) -> BottomInputView2 {
        let toolHeight: CGFloat = 49.0 + kBottomSpace
        let tool = BottomInputView2.init(frame: CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: toolHeight))
        
        tool.originalFrame = CGRect(x: 0.0, y: kHeight - 49.0 - kBottomSpace, width: kWidth, height: 49.0)
        tool.initSubViews()
        tool.registerNote()
        tool.textCallBack = block

        return tool
    }

    /// 注册通知
    func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            self.transform = CGAffineTransform.init(translationX: 0.0, y: -height + kBottomSpace)
            self.keyboradHeight = height
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            self.transform = CGAffineTransform.identity
        }
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            self.changeTextViewHeight()
        }
    }
    /// 销毁通知
    func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
        NotificationCenter.default.removeObserver(self.note3)
    }
    
    //MARK: -实现部分
    /// 点击文字回调
    private var textCallBack: ((String)->Void)?
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
    /// 原始位置
    private var originalFrame: CGRect!
    /// 标记换行
    private var lastHeight: CGFloat!
    /// 键盘高度
    private var keyboradHeight: CGFloat!
    
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
    
    /// 添加控件
    private func initSubViews() {
        
        self.addSubview(self.rightBtn)
        self.isBtnEnabled = false
        self.addSubview(self.textView)
    }
    
    /// 更改试图frame
    private func changeTextViewHeight() {
        
        let text: String = self.textView.text ?? ""
        self.isBtnEnabled = !text.isEmpty
        
        let textHeight = self.textView.sizeThatFits(CGSize(width: self.textView.k_width, height: kHeight)).height
        if self.lastHeight == nil { self.lastHeight = textHeight }

        if self.lastHeight != textHeight {
            
            // 输入框
            var tVFrame = self.textView.frame
            tVFrame.size.height = textHeight
            
            // 父视图
            var newFrame = self.frame
            newFrame.size.height = tVFrame.maxY + tVFrame.origin.y + self.keyboradHeight
            newFrame.origin.y = kHeight - newFrame.size.height
            
            // 按钮
            var btnFrame = self.rightBtn.frame
            btnFrame.origin.y = tVFrame.maxY - self.btnHeight
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.frame = newFrame
                self.textView.frame = tVFrame
                self.rightBtn.frame = btnFrame
            })
            self.lastHeight = textHeight
        }
    }
    
    //MARK: -Lazy
    private lazy var textView: UITextView = { [unowned self] in
        let textView = UITextView.init(frame: CGRect(x: self.tFLeftMargin, y: 0.0, width: kWidth - self.tFLeftMargin - self.tFRightMargin - self.btnWidth - self.btnRightMargin, height: 0.0))
        
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.layer.cornerRadius = 5.0
        textView.clipsToBounds = true
        textView.isScrollEnabled = false

        textView.k_height = textView.sizeThatFits(CGSize(width: textView.k_width, height: kHeight)).height
        textView.k_y = (self.originalFrame.height - textView.k_height) / 2.0
        
        return textView
    }()
    
    private lazy var rightBtn: UIButton = { [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发送", for: .normal)
        btn.frame = CGRect(x: self.originalFrame.width - self.btnWidth - self.btnRightMargin, y: (self.originalFrame.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in
            
            self.textCallBack?(self.textView.text!)
            self.textView.text = nil
            self.changeTextViewHeight()
        }
        
        return btn
    }()
    
    lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async {
                
                self.textView.resignFirstResponder()
                UIView.animate(withDuration: 0.25, animations: {
                    
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
