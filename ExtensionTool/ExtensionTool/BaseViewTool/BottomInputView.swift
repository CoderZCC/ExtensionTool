//
//  BottomInputView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BottomInputView: UIView {

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
            self.transform = CGAffineTransform.init(translationX: 0.0, y: -height + kBottomSpace)
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            self.transform = CGAffineTransform.identity
        }
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            let textView = note.object as! UITextView
            let text: String = textView.text ?? ""
            
            var textHeight = self.getInputTextHeight(text: text)
            if self.lastHeight != textHeight {

                // 输入框
                var tVFrame = textView.frame
                tVFrame.size.height = textHeight - (self.originalFrame.height - self.tFHeight)
                tVFrame.size.height = max(self.originalTVFrame.height, tVFrame.size.height)

                // 父视图
                var newFrame = self.frame
                textHeight = max(self.originalFrame.height, textHeight)
                newFrame.size.height = textHeight
                newFrame.origin.y -= (textHeight - self.frame.height)
                
                // 按钮
                var btnFrame = self.rightBtn.frame
                btnFrame.origin.y = (newFrame.size.height - self.btnHeight) - (self.originalFrame.height - self.btnHeight) / 2.0
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.frame = newFrame
                    textView.frame = tVFrame
                    self.rightBtn.frame = btnFrame
                })
                self.lastHeight = textHeight
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
        
        return textView
    }()
    
    private lazy var rightBtn: UIButton = { [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "emoij"), for: .normal)
        btn.frame = CGRect(x: self.bounds.width - self.btnWidth - self.btnRightMargin, y: (self.bounds.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in
            
            
        }
        
        return btn
    }()
    
    deinit {
        
        self.destroyNote()
        print("###\(self)销毁了###\n")
    }
}
