//
//  LoadingTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIResponder {
    
    /// 进度框 带文字
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - progress: 进度
    func showProgress(_ text: String, progress: CGFloat) {
        
        if Thread.isMainThread {
            
            LoadingTool.sharedInstance.showProgressHUD(text, progress: progress)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showProgress(text, progress: progress)
            }
        }
    }
    
    /// 加载不带文字 支持点击取消
    @objc func showLoadingCanCancle() {
        
        if Thread.isMainThread {
            
            LoadingTool.sharedInstance.showLoading(nil, isClickCancle: true)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showLoadingCanCancle()
            }
        }
    }
    
    /// 加载框带文字 无法点击取消
    ///
    /// - Parameter text: 文字
    @objc func showLoading(_ text: String? = nil) {
        
        if Thread.isMainThread {
            
            LoadingTool.sharedInstance.showLoading(text, isClickCancle: false)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showLoading(text)
            }
        }
    }
    
    /// 可以翻转
    ///
    /// - Parameter text:
    func showTextWithHorizontal(_ text: String) {
        
        LoadingTool.sharedInstance.isTurn = true
        self.showText(text)
    }
    
    /// 提示信息 带文字
    ///
    /// - Parameter text: 文字
    @objc func showText(_ text: String?) {
        
        if Thread.isMainThread {
            
            LoadingTool.sharedInstance.showTextAutoHidden(text)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showText(text)
            }
        }
    }
    
    /// 隐藏试图
    @objc func hideHUD() {
        
        if Thread.isMainThread {
            
            LoadingTool.sharedInstance.hiddenAllHUD()

        } else {
            
            DispatchQueue.main.async {
                
                self.hideHUD()
            }
        }
    }
}

class LoadingTool: UIView {
    
    /// 全局对象
    static let sharedInstance: LoadingTool = LoadingTool(frame: UIScreen.main.bounds)
    /// 是否可以翻转屏幕
    var isTurn: Bool = false
    
    /// 自动消失时间
    static private let hiddenDuarion: TimeInterval = 1.2
    //MARK: -文字框
    private let textFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 文字框的圆角大小
    private let textCornerRadius: CGFloat = 4.0
    /// 文字框的最大宽度
    private let textMaxWidth: CGFloat = UIScreen.main.bounds.width - 100.0
    /// 文字框的最小高度
    private let textMinHeight: CGFloat = 38.0
    
    //MARK: -黑色背景框
    /// 黑色背景不带文字的尺寸
    private let blackSizeWithoutT: CGSize = CGSize(width: 80.0, height: 80.0)
    /// 黑色背景带文字的尺寸
    private let blackSizeWithT: CGSize = CGSize(width: 100.0, height: 100.0)
    /// 黑色背景圆角大小
    private let blackCornerRadius: CGFloat = 4.0
    
    //MARK: -进度条
    private var progressLayer: CAShapeLayer?
    
    /// 父视图数组
    private var baseViewsArr: [UIWindow] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.01)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 文字
    private lazy var textL: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = "提示文字"
        label.cornerRadius = self.textCornerRadius
        label.clipsToBounds = true
        label.numberOfLines = 0

        return label
    }()
    /// 黑色的背景
    private lazy var blackView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.black
        view.cornerRadius = self.blackCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    /// 大白菊花
    private lazy var activeView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.hidesWhenStopped = true
        
        return view
    }()
    /// 点击手势
    private lazy var tapPan: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapCancleAction))
        
        return tap
    }()
    /// 进度条View
    lazy var progressView: UIView = {
        
        let width: CGFloat = 45.0
        let progressView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: width))
        progressView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        progressView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        
        let circle = UIBezierPath(ovalIn: CGRect.init(x: 0.0, y: 0.0, width: width, height: width))
        
        // 圆环
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        shapeLayer.position = progressView.center
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.path = circle.cgPath
        
        progressView.layer.addSublayer(shapeLayer)
        
        self.progressLayer = shapeLayer
        
        return progressView
    }()
    
    static private var baseView: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.isHidden = false
        window.windowLevel = UIWindow.Level.alert
        window.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        
        LoadingTool.sharedInstance.baseViewsArr.append(window)
        
        return window
    }
}

extension LoadingTool {
    
    /// 展示圆环进度条
    ///
    /// - Parameters:
    ///   - text: 底部文字不能为空
    ///   - progress: 进度 0.0~1.0
    ///   - block: 完成的回调
    func showProgressHUD(_ text: String, progress: CGFloat, block: (()->Void)? = nil) {
        
        // 防止重复添加
        if self.blackView.superview == nil {
            
            if self.textL.superview != nil {
                
                self.textL.text = nil
                self.textL.frame = CGRect.zero
                self.textL.transform = CGAffineTransform.identity
                self.textL.removeFromSuperview()
            }
            
            LoadingTool.baseView.addSubview(self)
            self.blackView.alpha = 1.0
            self.addSubview(self.blackView)
            
            self.showProgressWith(text)

        } else {
            
            UIView.animate(withDuration: 0.25) {
                
                self.activeView.stopAnimating()
                self.activeView.removeFromSuperview()
                
                self.showProgressWith(text)
            }
        }
        self.progressLayer?.strokeEnd = progress
        if progress >= 1.0 {
            
            self.progressView.alpha = 0.0
            self.progressLayer?.strokeEnd = 0.0
            self.progressView.removeFromSuperview()
            
            self.textL.text = nil
            self.textL.alpha = 0.0
            self.textL.frame = CGRect.zero
            self.textL.removeFromSuperview()
            
            self.blackView.removeFromSuperview()
            self.removeFromSuperview()
            
            block?()
        }
    }
}

extension LoadingTool {
    
    /// 展示菊花 或者 (菊花 + 文字)
    ///
    /// - Parameters:
    ///   - text: 文字 默认nil
    ///   - isClickCancle: 是否支持点击取消loading
    func showLoading(_ text: String? = nil, isClickCancle: Bool = false) {
        
        // 防止重复添加
        if self.blackView.superview == nil {
            
            if self.textL.superview != nil {
                
                self.textL.text = nil
                self.textL.frame = CGRect.zero
                self.textL.transform = CGAffineTransform.identity
                self.textL.removeFromSuperview()
            }
            
            LoadingTool.baseView.addSubview(self)
            self.blackView.alpha = 1.0
            self.addSubview(self.blackView)
            
            if isClickCancle {
                
                self.addGestureRecognizer(self.tapPan)
                
            } else {
                
                self.removeGestureRecognizer(self.tapPan)
            }
        }
        
        if let text = text {
            
            // 防止重复添加
            if self.textL.superview == nil {
                
                if self.activeView.isAnimating {
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        
                        // 菊花 变为 (菊花 + 文字)
                        self.showHUDWithText(text)
                    })
                } else {
                    
                    // 菊花 + 文字
                    self.showHUDWithText(text)
                }
            } else {
                
                self.textL.text = text
            }
            
        } else {
            
            // 防止重复添加
            if self.activeView.superview == nil {
                
                // 菊花
                self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithoutT)
                self.blackView.addSubview(self.activeView)
                self.activeView.center = self.blackView.center
                self.blackView.center = self.center
                
                self.activeView.startAnimating()
                
            } else {
                
                // (菊花 + 文字) 变为 菊花
                if self.textL.superview != nil {
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        
                        self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithoutT)
                        self.blackView.addSubview(self.activeView)
                        self.activeView.center = self.blackView.center
                        self.blackView.center = self.center
                        
                        self.activeView.startAnimating()
                        
                        self.textL.text = nil
                        self.textL.alpha = 0.0
                        self.textL.frame = CGRect.zero
                        self.textL.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    /// 移除loadingHUD
    @objc func hiddenLoadingHUD() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.blackView.alpha = 0.0
            
        }) { (isOk) in
            
            self.activeView.stopAnimating()
            self.activeView.removeFromSuperview()
            
            if self.textL.superview != nil {
                
                self.textL.text = nil
                self.textL.alpha = 0.0
                self.textL.frame = CGRect.zero
                self.textL.removeFromSuperview()
            }
            
            self.blackView.removeFromSuperview()
            
            self.removeFromSuperview()
            self.baseViewsArr.removeAll(keepingCapacity: false)
        }
    }
    
    /// 展示提示文字
    /// 自动消失 弹出期间不可操作
    /// - Parameter text: 文字 为 nil 不操作
    func showTextAutoHidden(_ text: String?) {
        
        guard let text = text else {
            
            self.hiddenAllHUD()
            return
        }
        // 移除loading
        if self.blackView.superview != nil {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.blackView.alpha = 0.0
            })
            self.activeView.stopAnimating()
            self.blackView.removeFromSuperview()
            self.activeView.removeFromSuperview()

            if self.textL.superview != nil {
                
                self.textL.text = nil
                self.textL.alpha = 0.0
                self.textL.frame = CGRect.zero
                self.textL.removeFromSuperview()
            }
        }
        // 取消延迟操作
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hiddenTextHUD), object: nil)
        // 防止重复添加
        if self.textL.superview == nil {
            
            LoadingTool.baseView.addSubview(self)
            self.addSubview(self.textL)
            self.textL.alpha = 1.0
        }
        // 赋值文字
        self.textL.text = text
        self.textL.sizeToFit()
        if self.textMaxWidth >= self.textL.bounds.width + 15.0 {
            
            self.textL.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: self.textL.bounds.width + 15.0, height: min(self.textL.bounds.height + 15.0, self.textMinHeight)))

        } else {
            
            self.textL.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: self.textMaxWidth, height: self.textSize(text, font: self.textFont) + 15.0))
        }
        self.textL.center = self.center
        
        if self.isTurn {
            
            let orient = UIDevice.current.orientation
            switch orient {
            case .portrait :
                
                // 竖屏
                self.textL.transform = CGAffineTransform.identity
                
            case .landscapeLeft:
                
                // 左翻转
                self.textL.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
                
            case .landscapeRight:
                
                // 右翻转
                self.textL.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
                
            default:
                
                break
            }
            self.isTurn = false
        }
        
        // 自动移除
        self.perform(#selector(hiddenTextHUD), with: nil, afterDelay: LoadingTool.hiddenDuarion)
    }
    
    /// 移除文字HUD
    @objc func hiddenTextHUD() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.textL.alpha = 0.0

        }) { (isOk) in
            
            self.textL.text = nil
            self.textL.frame = CGRect.zero
            self.textL.transform = CGAffineTransform.identity
            self.textL.removeFromSuperview()

            self.removeFromSuperview()
            self.baseViewsArr.removeAll(keepingCapacity: false)
        }
    }
    
    /// 移除所有HUD
    @objc func hiddenAllHUD() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 0.0
            
        }) { (isOk) in
            
            if self.activeView.superview != nil {
                
                self.activeView.stopAnimating()
                self.activeView.removeFromSuperview()
            }
            
            if self.textL.superview != nil {
                
                self.textL.text = nil
                self.textL.alpha = 0.0
                self.textL.frame = CGRect.zero
                self.textL.removeFromSuperview()
            }
            
            if self.blackView.superview != nil {
                
                self.blackView.removeFromSuperview()
            }
            
            self.alpha = 1.0
            self.removeFromSuperview()
            self.baseViewsArr.removeAll(keepingCapacity: false)
        }
    }
}

extension LoadingTool {
    
    /// 单击移除loading
    @objc private func tapCancleAction() {
        
        self.hiddenLoadingHUD()
    }
    
    /// 展示 进度
    private func showProgressWith(_ text: String) {
        
        self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithT)
        self.progressView.alpha = 1.0
        self.blackView.addSubview(self.progressView)
        self.progressView.center = CGPoint(x: self.blackView.center.x, y: self.blackView.center.y - 10.0)
        
        self.blackView.center = self.center
        
        self.textL.alpha = 1.0
        self.textL.text = text
        self.textL.frame = CGRect(x: 0.0, y: self.progressView.frame.maxY + 8.0, width: self.blackView.bounds.width, height: 20.0)
        self.blackView.addSubview(self.textL)
    }
    
    /// 展示 (菊花 + 文字)
    private func showHUDWithText(_ text: String) {
        
        self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithT)
        self.blackView.addSubview(self.activeView)
        self.activeView.center = CGPoint(x: self.blackView.center.x, y: self.blackView.center.y - 10.0)
        self.blackView.center = self.center
        
        self.activeView.startAnimating()
        
        self.textL.removeFromSuperview()
        self.textL.alpha = 1.0
        self.textL.text = text
        self.textL.frame = CGRect(x: 0.0, y: self.activeView.frame.maxY + 8.0, width: self.blackView.bounds.width, height: 20.0)
        self.blackView.addSubview(self.textL)
    }
    
    /// 计算文字高度
    private func textSize(_ text: String, font: UIFont) -> CGFloat {
        let str = NSString(string: text)
        let rect = str.boundingRect(with: CGSize(width: self.textMaxWidth, height: 300.0), options: .usesLineFragmentOrigin, attributes: [.font : self.textFont], context: nil)
        
        return rect.size.height
    }
}
