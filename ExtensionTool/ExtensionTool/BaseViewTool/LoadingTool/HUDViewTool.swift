//
//  HUDViewTool.swift
//  SwiftHUDTool
//
//  Created by 张崇超 on 2018/5/9.
//  Copyright © 2018年 zcc. All rights reserved.
//

import UIKit

extension NSObject {
    
    //MARK: -加载框 带文字
    func showProgress(progress: CGFloat, text: String) {
        
        if Thread.isMainThread {
            
            HUDViewTool.showProgress(progress: progress, text: text, isFinish: nil)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showProgress(progress: progress, text: text)
            }
        }
    }
    
    /// 加载不带文字 支持点击取消
    func showLoadingSupportClick() {
        
        if Thread.isMainThread {
            
            HUDViewTool.showLoading(text: nil, isClickCancle: true)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showLoadingSupportClick()
            }
        }
    }
        
    /// 加载框带文字 无法点击取消
    func showLoading(_ text: String? = nil) {
        
        if Thread.isMainThread {
            
            HUDViewTool.showLoading(text: text, isClickCancle: false)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showLoading(text)
            }
        }
    }
    
    /// 提示信息 带文字
    func showText(_ text:String?) {
        
        guard let text = text else {
            
            self.hideHUD()
            return
        }
        
        if Thread.isMainThread {
            
            if !HUDViewTool.windows.isEmpty {
                
                self.hideHUD()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    
                    HUDViewTool.showText(text: text)
                }
                
            } else {
                
                HUDViewTool.showText(text: text)
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showText(text)
            }
        }
    }
    /// 隐藏试图
    func hideHUD() {
        
        if Thread.isMainThread {
            
            HUDViewTool.removeAllHUD()
            
        } else {
            
            DispatchQueue.main.async {
                
                self.hideHUD()
            }
        }
    }
}

class HUDViewTool: UIView {

    /// 单例
    static let initTool: HUDViewTool = HUDViewTool.loadXibView()
    /// 展示的Windows
    static var windows: Array<UIWindow?> = Array<UIWindow?>()
    
    /// 菊花+文字
    @IBOutlet private weak var circleTextView: UIView!
    @IBOutlet private weak var aiView1: UIActivityIndicatorView!
    @IBOutlet private weak var titleL1: UILabel!
    
    /// 菊花
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var aiView2: UIActivityIndicatorView!
    
    /// 文字
    @IBOutlet private weak var textView: UIView!
    @IBOutlet private weak var titleL3: UILabel!
    @IBOutlet private weak var textWidthCons: NSLayoutConstraint!
    @IBOutlet private weak var textHeightCons: NSLayoutConstraint!
  
    /// 进度+文字
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var huanView: UIView!
    @IBOutlet private weak var titleL4: UILabel!
    
    /// 是否支持点击取消 默认为不支持
    private static var isClickCancle: Bool = false
    
    private static let textMaxW: CGFloat = kWidth - 100.0
    private static let textMinW: CGFloat = 100.0
    private static let textMinH: CGFloat = 30.0

    /// 是否是第一次加载进度条
    private static var isfirstRun: Bool = true
    /// 进度
    private static var progressLayer: CAShapeLayer!
    /// 动画是否运行结束
    private static var isAnimating: Bool = false
    
    // 初始化
    class func loadXibView() -> HUDViewTool {
        let tool = Bundle.main.loadNibNamed("HUDViewTool", owner: nil, options: nil)?.last as! HUDViewTool
        tool.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
        
        return tool
    }
    
    /// 展示文字 自动隐藏
    static func showText(text: String) {
        
        if HUDViewTool.isAnimating {
            
            return
        }
        HUDViewTool.isAnimating = true
        
        let tool = HUDViewTool.initTool
        tool.addWindow().addSubview(tool)
        HUDViewTool.isClickCancle = false
        tool.showView(view: nil)
        
        // 展示文字
        tool.showView(view: tool.textView)
        tool.titleL3.text = text
        var size = text.getTextSize(maxSize: CGSize.init(width: HUDViewTool.textMaxW, height: kHeight), font: UIFont.systemFont(ofSize: 14.0))
        size.width += 15.0
        size.height += 15.0

        // 文字宽度
        if size.width >= HUDViewTool.textMaxW {
            
            tool.textWidthCons.constant = HUDViewTool.textMaxW
            
        } else if size.width <= HUDViewTool.textMinW {
            
            tool.textWidthCons.constant = HUDViewTool.textMinW
            
        } else {
            
            tool.textWidthCons.constant = size.width
        }
        // 文字高度
        if size.height <= HUDViewTool.textMinH {
            
            tool.textHeightCons.constant = HUDViewTool.textMinH
            
        } else {
            
            tool.textHeightCons.constant = size.height
        }
        tool.layoutIfNeeded()
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait :
            
            // 竖屏
            tool.textView.transform = CGAffineTransform.identity
            
        case .landscapeLeft:
        
            // 左翻转
            tool.textView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
            
        case .landscapeRight:
            
            // 右翻转
            tool.textView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
            
        default:
            
            break
        }
        HUDViewTool.isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            
            HUDViewTool.removeAllHUD()
        })
    }
    
    /// 展示加载框 是否支持点击取消
    static func showLoading(text: String? = nil, isClickCancle: Bool? = false) {

        let tool = HUDViewTool.initTool
        tool.addWindow().addSubview(tool)
        tool.showView(view: nil)
        
        // 是否支持点击取消
        HUDViewTool.isClickCancle = isClickCancle ?? false

        if let text = text {
            
            tool.showView(view: tool.circleTextView)
            tool.aiView1.startAnimating()
            tool.titleL1.text = text
            tool.circleTextView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)

        } else {
            
            tool.showView(view: tool.circleView)
            tool.aiView2.startAnimating()
            tool.circleView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            if let _ = text {
                
                tool.circleTextView.transform = CGAffineTransform.identity
                
            } else {
                
                tool.circleView.transform = CGAffineTransform.identity
            }
            
        }) { (isOk) in
            
        }
    }
    
    /// 展示进度框
    static func showProgress(progress: CGFloat, text: String, isFinish: (()-> Void)? ) {
        
        let tool = HUDViewTool.initTool
        // 是否支持点击取消
        HUDViewTool.isClickCancle = false
        
        if HUDViewTool.isfirstRun {
            
            tool.addWindow().addSubview(tool)

            // 隐藏之前的
            tool.showView(view: nil)
            // 展示现在的
            tool.showView(view: tool.progressView)
            
            // 文字
            tool.titleL4.text = text
            // 进度
            tool.huanView.addSubview(tool.progress)
            
            tool.progressView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
                
                tool.progressView.transform = CGAffineTransform.identity
                
            }) { (isOk) in
                
            }
            HUDViewTool.isfirstRun = false
        }
        // 进度
        HUDViewTool.progressLayer.strokeEnd = progress
        if HUDViewTool.progressLayer.strokeEnd >= 1.0 {
            
            HUDViewTool.isfirstRun = true
        }
    }
    
    /// 创建一个 window
    func addWindow() -> UIWindow! {
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        HUDViewTool.windows.append(window)
        
        return window
    }
    
    // MARK: -展示指定的View
    func showView(view: UIView?) {
        
        let tool = HUDViewTool.initTool

        tool.textView.isHidden = true
        tool.circleTextView.isHidden = true
        tool.circleView.isHidden = true
        tool.progressView.isHidden = true
        
        view?.isHidden = false
    }

    // MARK: -移除所有HUD
    static func removeAllHUD(_ isFinsih:(() -> Void)? = nil ) {
        
        if let window = HUDViewTool.windows.first {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                window?.alpha = 0.0
                
            }) { (isOk) in
                
                let tool = HUDViewTool.initTool
                tool.aiView1.stopAnimating()
                tool.aiView2.stopAnimating()
                HUDViewTool.progressLayer?.strokeEnd = 0.0
                
                HUDViewTool.windows.removeAll(keepingCapacity: false)
                
                isFinsih?()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if HUDViewTool.isClickCancle {
            
            HUDViewTool.removeAllHUD()
        }
    }
    
    //MARK: -懒加载
    lazy var progress: UIView = {
        
        let width: CGFloat = 45.0
        let progressView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: width, height: width))
        progressView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        progressView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
        
        let circle = UIBezierPath.init(ovalIn: CGRect.init(x: 0.0, y: 0.0, width: width, height: width))

        // 圆环
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: width, height: width)
        shapeLayer.position = progressView.center
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.path = circle.cgPath
        
        progressView.layer.addSublayer(shapeLayer)
        
        HUDViewTool.progressLayer = shapeLayer
        
        return progressView
    }()
}

extension String {
    
    //MARK:- 计算文字大小
    func getTextSize(maxSize:CGSize ,font:UIFont) -> CGSize {
        
        let str = self as NSString
        let rect = str.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
        
        return rect.size
    }
}
