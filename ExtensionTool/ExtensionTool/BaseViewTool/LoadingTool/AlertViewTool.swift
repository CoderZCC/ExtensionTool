//
//  KAlertTools.swift
//  Swift代码练习
//
//  Created by 张崇超 on 2017/7/25.
//  Copyright © 2017年 huayu. All rights reserved.
//

import UIKit

extension NSObject {
 
    /// 展示操作弹窗
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 文字
    ///   - leftText: 左侧按钮文字
    ///   - rightText: 右侧按钮文字
    ///   - leftAction: 左侧按钮回调
    ///   - rightAction: 右侧按钮回调
    func showAlertView(title: String?, message: String?, leftText: String? = nil, rightText: String? = nil, leftAction:(()->Void)? = nil, rightAction: (()->Void)?) {
        
        AlertViewTool.showAlertView(title: title, subTitle: message, leftBtn: leftText, rightBtn: rightText, leftBtnAction: {
            
            leftAction?()
            
        }) {
            rightAction?()
        }
    }
    
    /// 展示操作弹窗带有输入框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - placeholder:占位文字
    ///   - leftText: 左侧按钮文字
    ///   - rightText: 右侧按钮文字
    ///   - leftAction: 左侧按钮回调
    ///   - rightAction: 右侧按钮回调
    func showAlertViewWithTextField(title: String?, placeholder: String?, leftText: String? = nil, rightText: String? = nil, leftAction: (()->Void)?, rightAction: ((String)->Void)?) {
        
        AlertViewTool.showAlertTextFieldView(title: title, placeholder: placeholder, leftBtn: leftText, rightBtn: rightText, leftAction: {
            
            leftAction?()

        }) { (str) in
            
            rightAction?(str)
        }
    }
}

class AlertViewTool: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleL: UILabel!
    @IBOutlet private weak var subTitleL: UILabel!
    @IBOutlet private weak var leftBtn: UIButton!
    @IBOutlet private weak var rightBtn: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var centerSpace: NSLayoutConstraint!
    
    private var leftAction:()->Void = {}
    private var rightAction:()->Void = {}
    private var finishInput:(String) ->Void = {_ in}
    private var isRunning:Bool  = false
    
    ///单例
    static let sharedManager: AlertViewTool = {
        
        let tool = Bundle.main.loadNibNamed("AlertViewTool", owner: nil, options: nil)?.last as! AlertViewTool
        tool.frame = CGRect(x:0 , y: 0 ,width: kWidth ,height: kHeight)
        tool.contentView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        
        return tool
    }()
    
    ///输入框
    class func showAlertTextFieldView (title:String? , placeholder:String? ,leftBtn:String? = "取消" ,rightBtn:String? = "确定" ,leftAction:@escaping ()->Void ,rightAction:@escaping (String)->Void)
    {
        let tool = AlertViewTool.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        tool.centerSpace.constant -= 40.0

        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)
        
        tool.subTitleL.isHidden = true
        tool.textField.isHidden = false
        tool.textField.text = nil
        //赋值
        if let title = title {
            
            tool.titleL.text = title
        }
        if let placeholder = placeholder {
            
            tool.textField.placeholder = placeholder
        }
        
        if let leftBtn = leftBtn {
            
            tool.leftBtn.setTitle(leftBtn, for: UIControl.State.normal)
        }
        if let rightBtn = rightBtn {
            
            tool.rightBtn.setTitle(rightBtn, for: UIControl.State.normal)
        }
        
        tool.finishInput = rightAction
        tool.leftAction = leftAction
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.contentView.transform = CGAffineTransform.identity
            
        }) { (isOk) in
            
            tool.textField.becomeFirstResponder()
            tool.isRunning = false
        }
    }
    
    ///警告框
    class func showAlertView(title:String? , subTitle:String? , leftBtn:String? = "取消", rightBtn:String? = "确定",leftBtnAction:@escaping ()->Void ,rightBtnAction:@escaping () ->Void)
    {
        let tool = AlertViewTool.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)

        //赋值
        tool.subTitleL.isHidden = false
        tool.textField.isHidden = true
        
        if let title = title {
            
            tool.titleL.text = title
        }
        if let subTitle = subTitle {
            
            tool.subTitleL.text = subTitle
        }
        if let leftBtn = leftBtn {
            
            tool.leftBtn.setTitle(leftBtn, for: UIControl.State.normal)
        }
        if let rightBtn = rightBtn {
            
            tool.rightBtn.setTitle(rightBtn, for: UIControl.State.normal)
        }
        
        tool.rightAction = rightBtnAction
        tool.leftAction = leftBtnAction

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.contentView.transform = CGAffineTransform.identity

        }) { (isOk) in
            
            tool.isRunning = false
        }
    }
    
    ///隐藏
    class func dismissView()
    {
        let tool = AlertViewTool.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        UIView.animate(withDuration: 0.3, animations: {
            
            tool.alpha = 0.0
            tool.contentView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            
        }) { (isFinish) in
            
            tool.isRunning = false
            tool.removeFromSuperview()
            //复原
            if tool.textField.isHidden == false {
                
                tool.centerSpace.constant += 40.0
            }
        }
    }
    
    //MARK: -Action-
    @IBAction func btnAction(_ sender: UIButton) {
        
        let tool = AlertViewTool.sharedManager
        AlertViewTool.dismissView()
        if sender.tag == 100 {
            
            //左侧按钮
            tool.leftAction()
            
        }else if (sender.tag == 101) {
            
            if tool.textField.isHidden {
                
                //右侧按钮
                tool.rightAction()
            }else{
                
                if let text = tool.textField.text {
                    
                    tool.finishInput(text)
                }
            }
        }
    }
}
