//
//  BottomInputView5.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/3.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BottomInputView5: UIView {
    
    class func initViewWith(_ inputView: UITextView) -> BottomInputView5 {
        let toolHeight: CGFloat = 49.0 + kBottomSpace
        let tool = BottomInputView5.init(frame: CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: toolHeight))
        tool.k_height += tool.extraHeight
        tool.originalFrame = CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: 49.0)

        tool.registerNote()
        tool.initSubViews()
        tool.textView = inputView
        
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
            self.emoijView.alpha = 0.0
            self.isClickBtn = false
            self.transform = CGAffineTransform.init(translationX: 0.0, y: -height)
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            if !self.isClickBtn {
                
                self.transform = CGAffineTransform.identity
            }
        }
    }
    /// 销毁通知
    func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
    }
    
    /// 额外的高度 键盘收起时.展示emoijView
    private var extraHeight: CGFloat = 200.0 + kBottomSpace
    /// 是否点击了按钮
    private var isClickBtn: Bool = false
    /// 输入框
    private var textView: UITextView!
    /// 原始位置
    private var originalFrame: CGRect!
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    
    private func initSubViews() {
        
        self.addSubview(self.firstBtn)
        self.addSubview(self.emoijView)
    }
    
    // MARK: -Lazy
    lazy var firstBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 15.0, y: 0.0, width: self.originalFrame.height, height: self.originalFrame.height)
        btn.setImage(#imageLiteral(resourceName: "emoij"), for: .normal)
        btn.k_addTarget { [unowned self] in
        
            if self.isClickBtn { return }
            self.isClickBtn = true
            self.superview?.endEditing(true)
            UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                
                self.emoijView.alpha = 1.0
                self.transform = CGAffineTransform(translationX: 0.0, y: -self.extraHeight + kBottomSpace)
            })
        }
        
        return btn
    }()
    lazy var emoijView: EmoijView = {
        let view = EmoijView.init(frame: CGRect(x: 0.0, y: self.firstBtn.frame.maxY + self.firstBtn.frame.origin.y, width: self.bounds.width, height: self.extraHeight))
        view.alpha = 0.0
        view.clickCallBack = { [unowned self] str in
            
            if str.contains("delete") {
                
                if let text = self.textView.text, !text.isEmpty {
                    
                    self.textView.text.removeLast()
                }
                
            } else {
                
                self.textView.text.append(str)
            }
        }
        
        return view
    }()
    
    deinit {
        
        self.destroyNote()
        print("###\(self)销毁了###\n")
    }
}
