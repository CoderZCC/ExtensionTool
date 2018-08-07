//
//  CellDetailView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellDetailView: UIView {

    static func showDetail(baseView: UIImageView, playerView: VideoPlayerView, originalFrame: CGRect) {
        
        let tool = CellDetailView.init(frame: UIScreen.main.bounds)
        tool.k_setCornerRadius(baseView.layer.cornerRadius)
        tool.clipsToBounds = true
        
        // 添加视频View
        tool.addSubview(playerView)
        // 添加动画View
        tool.frame = originalFrame
        kWindow.addSubview(tool)
        
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
                    
                    baseView.addSubview(playerView)
                    tool.alpha = 0.0
                    tool.removeFromSuperview()
                })
            })
        }
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        
        
        
    }
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    

    
}
