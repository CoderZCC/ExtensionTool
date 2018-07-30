//
//  BottomInputView3.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 输入框(可换行) + 按钮 + 底部View
class BottomInputView3: UIView, UITextViewDelegate {

    //MARK: -调用部分
    /// 占位文字
    var placeHolder: String? {
        willSet {
            self.textView.k_placeholder = newValue
        }
    }
    /// 点击文字回调
    var textCallBack: ((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.originalFrame = frame
        self.initSubViews()
        self.registerNote()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSubViews()
        self.registerNote()
    }
    
    /// 注册通知
    func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            self.keyboradHeight = height
            self.transform = CGAffineTransform.init(translationX: 0.0, y: -self.keyboradHeight + kBottomSpace)
            
            self.isEditting = true
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            if self.isClickEmoij { return }
            self.transform = CGAffineTransform.identity
            self.isEditting = false
        }
        
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            let textView = note.object as! UITextView
            let text: String = textView.text ?? ""
            
            let textHeight = self.getInputTextHeight(text: text)

            if self.lastHeight != textHeight {

                // 输入框
                var tVFrame = textView.frame
                tVFrame.size.height = textHeight - (self.originalFrame.height - self.tFHeight)
                tVFrame.size.height = max(self.originalTVFrame.height, tVFrame.size.height)
                
                // 父视图
                var newFrame = self.frame
                newFrame.size.height = max(self.originalFrame.height, textHeight) + self.keyboradHeight
                newFrame.origin.y = kHeight - max(self.originalFrame.height, textHeight) - self.keyboradHeight
                
                // 按钮
                var btnFrame = self.rightBtn.frame
                btnFrame.origin.y = (newFrame.size.height - self.keyboradHeight - self.btnHeight) - (self.originalFrame.height - self.btnHeight) / 2.0
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.frame = newFrame
                    textView.frame = tVFrame
                    self.rightBtn.frame = btnFrame
                })
                self.lastHeight = textHeight
                // 偏移,防止文字展示不全
                textView.setContentOffset(CGPoint(x: 0.0, y: self.lastHeight == self.originalTVFrame.height ? (0.0): (4.0)), animated: true)
            }
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
    /// 输入框原始位置
    private var originalTVFrame: CGRect!
    /// 标记换行
    private var lastHeight: CGFloat!
    /// 键盘高度
    private var keyboradHeight: CGFloat!
    /// 键盘是否弹出
    private var isEditting: Bool = false
    /// 额外的高度 键盘收起时.展示emoijView
    private var extraHeight: CGFloat = 240.0
    /// 是否点击了emoij
    private var isClickEmoij: Bool = false
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    private var note3: NSObjectProtocol!
    
    /// 添加控件
    private func initSubViews() {
        
        self.addSubview(self.rightBtn)
        self.addSubview(self.textView)
    }
    
    /// 计算文字高度
    private func getInputTextHeight(text: String) -> CGFloat {
        
        if text.isEmpty {
            
            return self.originalTVFrame.height
        }
        let str = NSString.init(string: text)
        let rect = str.boundingRect(with: CGSize.init(width: self.textView.frame.width - 10.0, height: 999.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : self.textView.font!], context: nil)
        return max(rect.size.height + 13.0, self.originalTVFrame.height)
    }
    
    //MARK: -Lazy
    private lazy var textView: UITextView = { [unowned self] in
        self.originalTVFrame = CGRect(x: self.tFLeftMargin, y: (self.bounds.height - self.tFHeight) / 2.0, width: kWidth - self.tFLeftMargin - self.tFRightMargin - self.btnWidth - self.btnRightMargin, height: self.tFHeight)
        self.lastHeight = self.originalTVFrame.height
        let textView = UITextView.init(frame: self.originalTVFrame)
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.layer.cornerRadius = 5.0
        textView.clipsToBounds = true
        textView.returnKeyType = .send
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var rightBtn: UIButton = { [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "emoij"), for: .normal)
        btn.frame = CGRect(x: self.bounds.width - self.btnWidth - self.btnRightMargin, y: (self.bounds.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in
            
            DispatchQueue.main.async {
                
                self.isClickEmoij = true
                if self.isEditting {
                    
                    self.textView.resignFirstResponder()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.transform = CGAffineTransform.init(translationX: 0.0, y: -self.extraHeight + kBottomSpace)
                })
                var newFrame = self.frame
                newFrame.size.height = self.extraHeight + self.originalFrame.height
                
                self.frame = newFrame
            }
        }
        
        return btn
    }()
    
    lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async {
                
                self.isClickEmoij = false
                self.textView.resignFirstResponder()
                
                UIView.animate(withDuration: 0.25, animations: {
                    
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
    
    //MARK: -UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && !textView.text.isEmpty {
            
            textView.resignFirstResponder()
            textCallBack?(textView.text!)
            
            textView.text = ""
            self.textView.k_placeholder = self.placeHolder
            
            return false
        }
        return true
    }
    
}
