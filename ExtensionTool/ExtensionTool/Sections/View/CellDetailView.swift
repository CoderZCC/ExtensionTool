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
    ///   - currentCell: 单元格
    ///   - playerView: 播放器
    ///   - originalFrame: 初始位置
    static func showDetail(currentCell: CellPlayerCell, playerView: VideoPlayerView, originalFrame: CGRect) {
        
        let tool = CellDetailView.init(frame: UIScreen.main.bounds)
        let baseView = currentCell.coverImgV!

        // 获取父视图
        let superView = currentCell.superview?.superview
        superView?.addSubview(tool.blackView)
        
        //  赋值
        tool.playerView = playerView
        tool.originlaiFrame = originalFrame
        tool.coverImg = baseView.image!
        tool.baseView = baseView
        // 删除原图片
        baseView.backgroundColor = UIColor.black
        baseView.image = nil
        
        // 添加视频View
        tool.addSubview(playerView)

        // 添加动画View
        tool.frame = originalFrame
        kWindow.addSubview(tool)
        // 添加拖动手势
        let pan = tool.panGesture
        playerView.addGestureRecognizer(pan)
        // 执行放大动画
        UIView.k_animate(withDuration: tool.showDuraton, usingSpringWithDamping: 0.7, animations: { [unowned tool] in
            
            tool.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
            playerView.frame = tool.bounds
            
        }) { [unowned tool] (isOk) in
            
            tool.k_addTarget({ [unowned tool] (tap) in
                
                // 先隐藏原图片
                tool.baseView.isHidden = true
                tool.baseView.image = tool.coverImg
                
                UIView.animate(withDuration: tool.hiddenDuration, animations: {
                    
                    tool.frame = originalFrame
                    playerView.frame = tool.bounds
                    
                }, completion: { (isOk) in
                    
                    // 展示原图片
                    tool.baseView.isHidden = false
                    // 移除手势
                    playerView.removeGestureRecognizer(pan)
                    // 添加到原父视图
                    baseView.addSubview(playerView)
                    // 移除子控件
                    tool.blackView.removeFromSuperview()
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
    /// 动画执行时间
    private var showDuraton: TimeInterval = 0.4
    private var hiddenDuration: TimeInterval = 0.25
    /// 缩放进度
    private var progress: CGFloat = 0.0
    /// 记录封面图
    private var coverImg: UIImage!
    
    // MARK: -事件
    @objc private func panAction(pan: UIPanGestureRecognizer) {

        let currentPoint = pan.location(in: self)
        switch pan.state {
        case .began:
            
            self.lastPoint = currentPoint

        case .changed:
            
            // 手指移动的比例
            let distance = sqrt(pow((currentPoint.x - self.lastPoint.x), 2) + pow((currentPoint.y - self.lastPoint.y), 2))
            self.progress = distance / (kHeight)
            print(self.progress)
            // 蒙版
            self.blackView.alpha = 1.0 - min(1.0, self.progress)
            // 播放器位移
            self.playerView.transform = CGAffineTransform(translationX: currentPoint.x - self.lastPoint.x, y: currentPoint.y - self.lastPoint.y)
            
            // 播放器缩放
            let progress = 1.0 - min(0.3, self.progress)
            var newFrame = self.playerView.frame
            newFrame.size.width = progress * kWidth
            newFrame.size.height = progress * kHeight
            self.playerView.frame = newFrame
            
        case .ended,.cancelled:

            UIView.animate(withDuration: self.hiddenDuration, animations: {
                
                // 恢复原位置大小
                self.frame = self.originlaiFrame
                self.playerView.frame = self.bounds
                // 蒙版
                self.blackView.alpha = 0.0
                
            }) { (isOk) in
                
                // 展示原图片
                self.baseView.image = self.coverImg
                // 恢复位移和缩放
                self.playerView.transform = CGAffineTransform.identity
                // 添加到原父视图
                self.baseView.image = self.coverImg
                self.baseView.addSubview(self.playerView)
                
                // 移除手势
                self.playerView.removeGestureRecognizer(pan)
                self.playerView.frame = self.bounds
                
                // 从父视图移除
                self.blackView.removeFromSuperview()
                self.removeFromSuperview()
            }
   
        default:
            break
        }
    }
    
    // MARK: -懒加载
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    // 黑色的蒙版
    lazy var blackView: UIView = {
        let view = UIView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        
        return view
    }()

    deinit {
        
        print("\n====\(self)销毁了====\n")
    }
    
}
