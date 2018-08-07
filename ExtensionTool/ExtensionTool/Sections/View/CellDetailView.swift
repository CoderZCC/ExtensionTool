//
//  CellDetailView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellDetailView: UIView {

    /// 初始化
    ///
    /// - Parameters:
    ///   - baseView: 父视图
    ///   - playerView: 播放器
    ///   - originalFrame: 初始位置
    static func showDetail(baseView: UIImageView, playerView: VideoPlayerView, originalFrame: CGRect) {
        
        let tool = CellDetailView.init(frame: UIScreen.main.bounds)
        tool.k_setCornerRadius(baseView.layer.cornerRadius)
        tool.clipsToBounds = true
        tool.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // 静音
        playerView.player?.volume = 0.0
        playerView.player?.pause()
        //  赋值
        tool.playerView = playerView
        tool.originlaiFrame = originalFrame
        tool.baseView = baseView
        
        // 添加视频View
        tool.addSubview(playerView)
        // 添加动画View
        tool.frame = originalFrame
        kWindow.addSubview(tool)
        // 添加拖动手势
        let pan = tool.panGesture
        playerView.addGestureRecognizer(pan)
        // 执行放大动画
        UIView.k_animate(withDuration: 0.25, usingSpringWithDamping: 0.7, animations: {
            
            tool.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
            playerView.frame = tool.bounds
            
        }) { (isOk) in
            
            tool.k_addTarget({ (tap) in
                
                UIView.k_animate(withDuration: 0.25, usingSpringWithDamping: 0.7, animations: {
                    
                    tool.frame = originalFrame
                    playerView.frame = tool.bounds
                    
                }, completion: { (isOk) in
                    
                    playerView.removeGestureRecognizer(pan)
                    baseView.addSubview(playerView)
                    tool.alpha = 0.0
                    tool.removeFromSuperview()
                })
            })
        }
    }
    
    /// 播放器
    private var playerView: VideoPlayerView!
    /// 记录上一次点击的点
    private var lastPoint: CGPoint = CGPoint.zero
    /// 记录初始位置
    private var originlaiFrame: CGRect!
    /// 父视图
    private var baseView: UIImageView!

    // MARK: -事件
    @objc private func panAction(pan: UIPanGestureRecognizer) {

        let currentPoint = pan.location(in: self)
        switch pan.state {
        case .began:
            
            self.lastPoint = currentPoint
            
        case .changed:
            
            self.playerView.transform = CGAffineTransform(translationX: currentPoint.x - self.lastPoint.x, y: currentPoint.y - self.lastPoint.y)
            
//            self.playerView.layer.removeAnimation(forKey: "scaleAni")
//
//            let scaleAni = CABasicAnimation.init(keyPath: "scale")
//            scaleAni.fillMode = kCAFillModeForwards
//            scaleAni.isRemovedOnCompletion = false
//
//            scaleAni.fromValue = NSNumber.init(value: 1.0)
//            scaleAni.toValue = NSNumber.init(value: 0.7)
//
//            self.playerView.layer.add(scaleAni, forKey: "scaleAni")
            
        case .ended,.cancelled:
            
            UIView.k_animate(withDuration: 0.25, usingSpringWithDamping: 0.7, animations: {
                
                self.playerView.frame = self.originlaiFrame
                
            }, completion: { (isOk) in
                
                self.playerView.transform = CGAffineTransform.identity
                self.playerView.removeGestureRecognizer(pan)
                self.baseView.addSubview(self.playerView)
                self.alpha = 0.0
                self.removeFromSuperview()
            })
            
        default:
            break
        }
    }
    
    // MARK: -懒加载
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    
    deinit {
        print("\n====\(self)销毁了====\n")
    }
    
}
