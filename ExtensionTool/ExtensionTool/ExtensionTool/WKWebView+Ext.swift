//
//  WKWebView+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {
    
    /// 进度条颜色 deinit时 置空以移除监听 (get方法永远为nil)
    var k_progressColor: UIColor? {
        set {
            
            guard let color = newValue else {
                
                if let view = self.progressView {
                    
                    view.removeFromSuperview()
                    self.removeObserver(self, forKeyPath: "estimatedProgress")
                }
                return
            }
            
            var progressView: UIProgressView? = self.progressView
            if progressView == nil {
                
                progressView = UIProgressView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 1.0))
                progressView?.tag = 950412
                // 放大尺寸
                progressView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.5)
                // 默认颜色
                progressView?.trackTintColor = UIColor.lightGray
                // 进度颜色
                progressView?.progressTintColor = color
                
                self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
                self.addSubview(progressView!)
            }
        }
        get { return nil }
    }
    /// 进度条
    private var progressView: UIProgressView? {
        
        return self.viewWithTag(101) as? UIProgressView
    }
    /// 监听进度
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let progressView = self.progressView else { return }
        guard let change = change else { return }
        
        if let value = (change[NSKeyValueChangeKey.newKey] as? NSNumber)?.doubleValue {
            
            self.bringSubview(toFront: progressView)
            
            progressView.isHidden = (value >= 1.0)
            progressView.setProgress( (value >= 1.0) ? (0.0) : (Float(value)), animated: !(value >= 1.0))
        }
    }
}
