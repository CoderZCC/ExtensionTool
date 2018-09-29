//
//  HUDTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/29.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

@objc extension UIResponder {
    
    /// 进度框 + 文字
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - progress: 进度 0.0~1.0
    func showProgress(_ text: String, progress: CGFloat) {
        
        if Thread.isMainThread {
            
            HUDTool.initSelf.showProgressHUD(text, progress: progress, block: nil)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showProgress(text, progress: progress)
            }
        }
    }
    
    /// 加载框 // 加载框 + 文字
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - canCancle: 是否点击取消
    func showLoading(_ text: String? = nil, canCancle: Bool = false) {
        
        if Thread.isMainThread {
            
            HUDTool.initSelf.showLoadingHUD(text, canCanle: false)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showLoading(text)
            }
        }
    }
    
    /// 文字框 可翻转
    ///
    /// - Parameter text: 文字
    func showTextWithHorizontal(_ text: String) {
        
        HUDTool.initSelf.isTurn = true
        self.showText(text)
    }
    
    /// 提示信息 带文字
    ///
    /// - Parameters:
    ///   - text: 文字
    func showText(_ text: String?) {
        
        guard let text = text else {
            
            self.hideHUD()
            return
        }
        
        if Thread.isMainThread {
            
            HUDTool.initSelf.showTextHUD(text)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showText(text)
            }
        }
    }
    
    /// 隐藏试图
    func hideHUD() {
        
        if Thread.isMainThread {
            
            HUDTool.initSelf.hidenLoadingHUD()
            
        } else {
            
            DispatchQueue.main.async {
                
                self.hideHUD()
            }
        }
    }
}

enum HUDType {
    case none, text, loading, loadingWithText, progress
}

class HUDTool: UIView {

    static let initSelf: HUDTool = HUDTool(frame: UIScreen.main.bounds)
    
    /// 是否可以翻转屏幕
    var isTurn: Bool = false
    
    //MARK: -文字框
    /// 自动消失时间
    private let hiddenDuarion: TimeInterval = 1.5
    /// 字体大小
    private let textFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    /// 文字框的圆角大小
    private let textCornerRadius: CGFloat = 4.0
    /// 文字框的最大宽度
    private let textMaxWidth: CGFloat = UIScreen.main.bounds.width - 100.0
    /// 文字框的最小高度
    private let textMinHeight: CGFloat = 35.0
    /// 定时器
    private var timer: DispatchSourceTimer?
    
    //MARK: -黑色背景框
    /// 黑色背景不带文字的尺寸
    private let blackSizeWithoutT: CGSize = CGSize(width: 80.0, height: 80.0)
    /// 黑色背景带文字的尺寸
    private let blackSizeWithT: CGSize = CGSize(width: 100.0, height: 100.0)
    /// 黑色背景圆角大小
    private let blackCornerRadius: CGFloat = 4.0
    
    //MARK: -进度条
    private var progressLayer: CAShapeLayer?
    
    //MARK: -辅助工具
    /// 当前展示类型
    private var showType: HUDType = .none
    /// 父视图数组
    private var baseViewsArr: [UIWindow] = []
    /// 是否可以点击取消
    private var canCancle: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        
        self.addSubview(self.blackView)
        // 文字框
        self.blackView.addSubview(self.textL)
        // 菊花 + 文字
        self.blackView.addSubview(self.activeView)
        // 进度 + 文字
        self.blackView.addSubview(self.progressView)
        
        // 隐藏
        self.showSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.canCancle {
            self.hidenLoadingHUD()
        }
    }
    
    private func startTimer() {
        
        if self.timer == nil {
            
            var count: Int = 0
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            self.timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: self.hiddenDuarion)
            self.timer?.setEventHandler { [unowned self] in
                
                if count == 1 {
                    
                    self.hidenTextHUD(true)
                    self.stopTimer()
                }
                count += 1
            }
            self.timer?.resume()
        }
    }
    
    private func stopTimer() {
        
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func getTextSize(_ text: String?, maxSize: CGSize) -> CGSize {
        
        guard let text = text else { return CGSize.zero }
        
        let rect = NSString(string: text).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.textFont], context: nil)
        return CGSize(width: min(rect.size.width + 15.0, self.textMaxWidth), height: max(rect.size.height + 15.0, self.textMinHeight))
    }
    
    private func showSubView(_ type: HUDType = .none) {
        
        self.stopTimer()
        self.blackView.isHidden = type == .none
        switch type {
        case .text:
            
            self.textL.isHidden = false
            self.activeView.stopAnimating()
            self.progressView.isHidden = true
            
        case .loading:
            
            self.textL.isHidden = true
            self.activeView.startAnimating()
            self.progressView.isHidden = true
            
        case .loadingWithText:
            
            self.textL.isHidden = false
            self.activeView.startAnimating()
            self.progressView.isHidden = true
            
        case .progress:
            
            self.textL.isHidden = false
            self.activeView.stopAnimating()
            self.progressView.isHidden = false
            
        default:
            
            self.textL.isHidden = true
            self.activeView.stopAnimating()
            self.progressView.isHidden = true
        }
    }
    
    // MARK: -lazy
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
    /// 进度条View
    private lazy var progressView: UIView = {
        
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

        HUDTool.initSelf.baseViewsArr.append(window)

        return window
    }
    
}

extension HUDTool {
    
    func showTextHUD(_ text: String?) {
        
        self.showSubView(.text)
        self.stopTimer()
        if self.superview == nil {
            
            HUDTool.baseView.addSubview(self)
        }
        
        self.textL.text = text
        self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.getTextSize(text, maxSize: CGSize(width: self.textMaxWidth, height: 200.0)))
        self.textL.frame = self.blackView.bounds
        self.blackView.center = self.center
        
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
        self.startTimer()
    }
    
    @objc func hidenTextHUD(_ isAnimated: Bool = true) {
        
        if isAnimated {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.blackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.blackView.alpha = 0.0
                
            }) { (isOk) in
                
                self.blackView.transform = CGAffineTransform.identity
                self.blackView.alpha = 1.0
                self.blackView.isHidden = true
                self.textL.isHidden = true
                
                self.removeFromSuperview()
                self.baseViewsArr.removeAll(keepingCapacity: false)
            }
            
        } else {
            
            self.textL.isHidden = true
        }
    }
}

extension HUDTool {
    
    func showLoadingHUD(_ text: String? = nil, canCanle: Bool = false) {
        
        self.showSubView(text == nil ? (.loading) : (.loadingWithText))
        self.canCancle = canCanle
        if self.superview == nil {
            
            HUDTool.baseView.addSubview(self)
        }
        
        self.blackView.frame = CGRect(origin: CGPoint.zero, size: text == nil ? (self.blackSizeWithoutT) : (self.blackSizeWithT))
        self.activeView.center = text == nil ? (self.blackView.center) : (CGPoint.init(x: self.blackView.center.x, y: self.blackView.center.y - 8.0))
        self.blackView.center = self.center
        self.activeView.startAnimating()
        
        self.textL.text = text
        self.textL.frame = CGRect(origin: CGPoint(x: 0.0, y: self.activeView.frame.maxY + 8.0), size: CGSize(width: self.blackSizeWithT.width, height: 20.0))
    }
    
    func hidenLoadingHUD(_ isAnimated: Bool = true) {
        
        if isAnimated {

            self.blackView.isHidden = true
            self.textL.isHidden = true
            self.activeView.stopAnimating()
            
            self.removeFromSuperview()
            self.baseViewsArr.removeAll(keepingCapacity: false)
//            UIView.animate(withDuration: 0.2, animations: {
//
//                self.blackView.alpha = 0.0
//                self.blackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//
//            }) { (isOk) in
//
//                self.blackView.alpha = 1.0
//                self.blackView.transform = CGAffineTransform.identity
//                self.blackView.isHidden = true
//                self.textL.isHidden = true
//                self.activeView.stopAnimating()
//
//                self.removeFromSuperview()
//                self.baseViewsArr.removeAll(keepingCapacity: false)
//            }
            
        } else {
            
            self.blackView.isHidden = true
            self.textL.isHidden = true
            self.activeView.stopAnimating()
        }
    }
}

extension HUDTool {
    
    func showProgressHUD(_ text: String, progress: CGFloat, block: (()->Void)? = nil) {
        
        self.showSubView(.progress)
        if self.superview == nil {
            
            HUDTool.baseView.addSubview(self)
        }
        if self.progressLayer?.strokeEnd == 0.0 {
            
            self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithT)
            self.progressView.center = CGPoint(x: self.blackView.center.x, y: self.blackView.center.y - 10.0)
            self.blackView.center = self.center
            
            self.textL.text = text
            self.textL.frame = CGRect(x: 0.0, y: self.progressView.frame.maxY + 8.0, width: self.blackView.bounds.width, height: 20.0)
        }
        self.progressLayer?.strokeEnd = progress
        if progress >= 1.0 {
            
            self.hidenProgressHUD(false)
            block?()
        }
    }
    
    func hidenProgressHUD(_ isAnimated: Bool = true) {
        
        if isAnimated {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.blackView.alpha = 0.0
                self.blackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
            }) { (isOk) in
                
                self.blackView.alpha = 1.0
                self.blackView.transform = CGAffineTransform.identity
                self.blackView.isHidden = true
                self.textL.isHidden = true
                self.progressView.isHidden = true
                self.progressLayer?.strokeEnd = 0.0

                self.removeFromSuperview()
                self.baseViewsArr.removeAll(keepingCapacity: false)
            }
            
        } else {
            
            self.blackView.isHidden = true
            self.textL.isHidden = true
            self.progressView.isHidden = true
            self.progressLayer?.strokeEnd = 0.0
        }
    }
    
}
