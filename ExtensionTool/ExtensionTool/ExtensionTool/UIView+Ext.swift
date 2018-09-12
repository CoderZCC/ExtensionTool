//
//  UIView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIView {
    
    // IBInspectble
    @IBInspectable var borderColor: UIColor? {
        set {
            self.layer.borderColor = newValue?.cgColor
        }
        get { return nil }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get { return 0.0 }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        get { return 0.0 }
    }
}

extension UIView {
    
    /// x
    var k_x: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
        get { return self.frame.origin.x }
    }
    /// y
    var k_y: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
        get { return self.frame.origin.y }
    }
    /// width
    var k_width: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
        get { return self.frame.size.width }
    }
    /// height
    var k_height: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
        get { return self.frame.size.height }
    }
    /// size
    var k_size: CGSize {
        set {
            
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
        get { return self.frame.size }
    }
    
    /// center
    var k_center: CGPoint {
        set {
            
            var newCenter = self.center
            newCenter = newValue
            self.center = newCenter
        }
        get { return self.center }
    }
    /// 中心点x
    var k_centerX: CGFloat {
        set {
            
            var newCenter = self.center
            newCenter.x = newValue
            self.center = newCenter
        }
        get { return self.center.x }
    }
    /// 中心点y
    var k_centerY: CGFloat {
        set {
            
            var newCenter = self.center
            newCenter.y = newValue
            self.center = newCenter
        }
        get {
            return self.center.y
        }
    }
}

var k_UIViewClickActionKey: Int = 0

extension UIView {
    
    //MARK: xib加载View
    /// xib加载View
    ///
    /// - Returns: UIView
    class func k_viewFromXib(size: CGSize = UIScreen.main.bounds.size) -> UIView {
        let className = NSStringFromClass(self)
        let xibView = Bundle.main.loadNibNamed(String(className), owner: nil, options: nil)?.last as! UIView
        xibView.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return xibView
    }
    
    //MARK: 设置为圆形控件
    /// 设置为圆形控件
    func k_setCircleImgV() {
        
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
    }
    
    //MARK: -添加一条线
    func k_addLineWith(_ color: UIColor, at: CGRect) {
        
        //添加自定义分割线
        let lineLayer = CALayer.init()
        lineLayer.removeFromSuperlayer()
        
        lineLayer.frame = at
        lineLayer.backgroundColor = color.cgColor
        self.layer.addSublayer(lineLayer)
    }
    
    //MARK: 设置圆角
    /// 设置圆角
    ///
    /// - Parameter radius: 圆角数
    func k_setCornerRadius(_ radius: CGFloat) {
        
//        self.layer.cornerRadius = radius
//        self.clipsToBounds = true
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: self.bounds.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //MARK: 设置边框
    /// 设置边框
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - width: 宽度
    func k_setBorder(color: UIColor, width: CGFloat) {
        
//        self.layer.borderColor = color.cgColor
//        self.layer.borderWidth = width
        
        let circleLayer = CAShapeLayer.init()
        
        let circlePath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2.0)
        circleLayer.path = circlePath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = width
        circleLayer.strokeColor = color.cgColor
        
        self.layer.addSublayer(circleLayer)
    }
    
    //MARK: 设置特定的圆角
    /// 设置特定的圆角
    ///
    /// - Parameters:
    ///   - corners: 位置
    ///   - radii: 圆角
    func k_setCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: CGRect.init(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: self.bounds.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //MARK: UIView添加点击事件
    /// UIView添加点击事件
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - action: 事件
    func k_addTarget(action: Selector) {
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: action)
        self.addGestureRecognizer(tap)
    }

    /// UIView添加点击事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addTarget(_ clickAction: ((UIGestureRecognizer)->Void)?) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// UIView添加长按事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addLongPressTarget(_ clickAction: ((UIGestureRecognizer)->Void)?) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// UIView点击事件
    @objc func k_tapAction(tap: UIGestureRecognizer) {
        
        (objc_getAssociatedObject(self, &k_UIViewClickActionKey) as! ((UIGestureRecognizer)->Void)?)?(tap)
    }
    
    //MARK: 单击移除键盘
    /// 单击移除键盘
    func k_tapDismissKeyboard() {
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapDismissAction))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (note) in
            
            self.addGestureRecognizer(tap)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: OperationQueue.main) { (note) in
            
            self.removeGestureRecognizer(tap)
        }
    }
    @objc func tapDismissAction() {
        
        self.endEditing(true)
    }
}


/// 国际化
extension UILabel {
    
    @IBInspectable var localizedString: String {
        set {
            self.text = NSLocalizedString(newValue, comment: "")
        }
        get { return "" }
    }
}

extension UIButton {
    
    @IBInspectable var localizedString: String {
        set {
            self.setTitle(NSLocalizedString(newValue, comment: ""), for: self.state)
        }
        get { return "" }
    }
}

extension UIView {
    
    static func k_animate(withDuration: TimeInterval, usingSpringWithDamping: CGFloat, animations: @escaping()->Void, completion: ((Bool)->Void)?) {
    
        UIView.animate(withDuration: withDuration, delay: 0.0, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: animations, completion: completion)
    }
    
}

