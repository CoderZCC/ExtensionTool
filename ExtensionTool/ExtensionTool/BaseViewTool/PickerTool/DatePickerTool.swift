//
//  DatePickerTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class DatePickerTool: UIView {

    /// 返回的字符串类型
    static var callbackStyle: String = "yyyy MM-dd HH:mm"
    
    /// 展示时间控件
    ///
    /// - Parameters:
    ///   - showModel: 展示类型
    ///   - currentTime: 显示的时间
    ///   - minimumDate: 最小时间
    ///   - maximumDate: 最大时间
    ///   - callback: 选中回调
    static func showView(showModel: UIDatePickerMode, currentTime: Date? = Date(), minimumDate: Date? = nil, maximumDate: Date? = Date(), callback: ((String)->Void)?) {
        
        let tool = DatePickerTool.loadXibView()
        tool.alpha = 0.0
        
        if tool.isAnimating { return }
        tool.isAnimating = true
        
        kWindow.addSubview(tool)
        tool.showView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
        
        if let currentTime = currentTime {
            tool.pickerView.setDate(currentTime, animated: true)
        }
        tool.pickerView.datePickerMode = showModel
        tool.pickerView.minimumDate = minimumDate
        tool.pickerView.maximumDate = maximumDate
        //tool.pickerView.locale = Locale.current
        
        tool.callback = callback
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.showView.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
            tool.isAnimating = false
        }
    }
    
    /// pickerView
    @IBOutlet weak private var pickerView: UIDatePicker!
    /// 展示View
    @IBOutlet weak private var showView: UIView!
    /// 是否在执行动画
    private var isAnimating: Bool = false
    /// 回调
    private var callback: ((String)->Void)?

    private class func loadXibView() -> DatePickerTool {
        let tool = Bundle.main.loadNibNamed("DatePickerTool", owner: nil, options: nil)?.first as! DatePickerTool
        tool.frame = UIScreen.main.bounds
        
        return tool
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
    /// 取消事件
    @IBAction private func cancleAction() {
        
        if self.isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)

        }) { (isOK) in
            
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    /// 确定事件
    @IBAction private func sureAction() {
        
        self.cancleAction()
        let timeStr = self.pickerView.date.k_toDateStr("yyyy MM-dd HH:mm")
        self.callback?(timeStr)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}
