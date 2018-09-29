//
//  HudTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/28.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

enum HUDType {
    case none, text, loading, progress
}

class HudTool: UIView {

    /// 全局对象
    static let initSelf: HudTool = HudTool(frame: UIScreen.main.bounds)
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
    /// 正在执行隐藏text
    private var isHiddening: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.001)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTimer() {
        
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
    
    func stopTimer() {
        
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func getTextSize(_ text: String?, maxSize: CGSize) -> CGSize {
        
        guard let text = text else { return CGSize.zero }
        
        let rect = NSString(string: text).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.textFont], context: nil)
        return CGSize(width: min(rect.size.width + 15.0, self.textMaxWidth), height: max(rect.size.height + 15.0, self.textMinHeight))
    }
    
    /// 文字
    private lazy var textL: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.font = self.textFont
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
    
//    static private var baseView: UIWindow {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.isHidden = false
//        window.windowLevel = UIWindow.Level.alert
//        window.backgroundColor = UIColor.white.withAlphaComponent(0.01)
//
//        HudTool.initSelf.baseViewsArr.append(window)
//
//        return window
//    }
    static private let baseView: UIWindow = kWindow
}

extension HudTool {
    
    /// 单击移除loading
    @objc private func tapCancleAction() {
        
        if self.showType == .loading {
            
            self.hidenLoadingHUD(true)
            
        } else if showType == .progress {
            
            self.hidenProgressHUD()
        }
    }
}

extension HudTool {
    
    func showTextHUD(_ text: String?) {
        
        if self.showType == .loading {
            
            self.hidenLoadingHUD(false)
            self.showTextHUD(text)
            
        } else if showType == .progress {
            
            self.hidenProgressHUD()
            self.showTextHUD(text)

        } else if showType == .text {
            
            self.stopTimer()

            self.textL.text = text
            self.textL.frame = CGRect(origin: CGPoint.zero, size: self.getTextSize(text, maxSize: CGSize(width: self.textMaxWidth, height: 200.0)))
            self.textL.center = self.center
         
            self.startTimer()

        } else {
            
            self.showType = .text
            if self.superview == nil {
                
                HudTool.baseView.addSubview(self)
            }
            self.addSubview(self.textL)
            self.textL.text = text
            self.textL.frame = CGRect(origin: CGPoint.zero, size: self.getTextSize(text, maxSize: CGSize(width: self.textMaxWidth, height: 200.0)))
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
            
            self.startTimer()
            self.textL.alpha = 0.0
            UIView.animate(withDuration: 0.2, animations: {
                
                self.textL.alpha = 1.0
            })
        }
    }
    
    @objc func hidenTextHUD(_ isAnimated: Bool = true) {
        
        if isAnimated {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.textL.alpha = 0.0
                self.textL.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
            }) { (isOk) in
                
                self.textL.alpha = 1.0
                self.textL.transform = CGAffineTransform.identity
                self.textL.removeFromSuperview()
                self.showType = .none
                
                self.removeFromSuperview()
                self.baseViewsArr.removeAll(keepingCapacity: false)
            }
            
        } else {
            
            self.showType = .none
            self.stopTimer()
            self.textL.alpha = 0.0
            self.textL.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                
                self.textL.alpha = 1.0
            }
        }
    }
}

extension HudTool {
    
    func showLoadingHUD(_ text: String? = nil, canCanle: Bool = false) {
        
        if self.showType == .text {
            
            self.hidenTextHUD(false)
            self.showLoadingHUD(text, canCanle: canCanle)
            
        } else if showType == .progress {
            
            self.hidenProgressHUD()
            self.showLoadingHUD(text, canCanle: canCanle)

        } else if showType == .loading {
            
            debugPrint("正在展示,不处理")

        } else {
            
            self.showType = .loading
            // 菊花
            if self.superview == nil {
                
                HudTool.baseView.addSubview(self)
            }
            self.addSubview(self.blackView)
            self.blackView.addSubview(self.activeView)

            // 添加手势
            canCanle ? (self.addGestureRecognizer(self.tapPan)) : (self.removeGestureRecognizer(self.tapPan))
            
            self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithoutT)
            self.activeView.center = self.blackView.center
            self.blackView.center = self.center
            self.activeView.startAnimating()
        }
    }
    
    func hidenLoadingHUD(_ isAnimated: Bool = true) {
        
        if isAnimated {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.blackView.alpha = 0.0
                self.blackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
            }) { (isOk) in
                
                self.showType = .none
                self.activeView.stopAnimating()
                self.activeView.removeFromSuperview()
                
                self.blackView.alpha = 1.0
                self.blackView.transform = CGAffineTransform.identity
                self.blackView.removeFromSuperview()
                
                self.removeFromSuperview()
                self.baseViewsArr.removeAll(keepingCapacity: false)
            }
            
        } else {
            
            self.showType = .none
            self.blackView.alpha = 0.0
            self.blackView.removeFromSuperview()
            
            self.activeView.stopAnimating()
            self.activeView.removeFromSuperview()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                
                self.blackView.alpha = 1.0
            }
        }
    }
}

extension HudTool {
    
    func showProgressHUD(_ text: String, progress: CGFloat, block: (()->Void)? = nil) {
        
        if self.showType == .text {
            
            self.hidenTextHUD(false)
            self.showProgressHUD(text, progress: progress, block: block)
            
        } else if showType == .loading {
            
            self.hidenLoadingHUD(false)
            self.showProgressHUD(text, progress: progress, block: block)
        
        } else if showType == .progress {
            
            self.progressLayer?.strokeEnd = progress
            if progress >= 1.0 {
                
                self.hidenProgressHUD()
                block?()
            }
            
        } else {
            
            self.showType = .progress
            
            HudTool.baseView.addSubview(self)
            self.addSubview(self.blackView)
            
            self.blackView.frame = CGRect(origin: CGPoint.zero, size: self.blackSizeWithT)
            self.blackView.addSubview(self.progressView)
            self.progressView.center = CGPoint(x: self.blackView.center.x, y: self.blackView.center.y - 10.0)
            
            self.blackView.center = self.center
            
            self.textL.text = text
            self.textL.frame = CGRect(x: 0.0, y: self.progressView.frame.maxY + 8.0, width: self.blackView.bounds.width, height: 20.0)
            self.blackView.addSubview(self.textL)
            
            self.progressLayer?.strokeEnd = progress
        }
    }
    
    func hidenProgressHUD() {
        
        self.showType = .none
        
        self.progressLayer?.strokeEnd = 0.0
        self.progressView.removeFromSuperview()
        
        self.textL.removeFromSuperview()
        
        self.blackView.transform = CGAffineTransform.identity
        self.blackView.removeFromSuperview()
        
        self.removeFromSuperview()
        self.baseViewsArr.removeAll(keepingCapacity: false)
    }
}
