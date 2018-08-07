//
//  PresentAnimation.swift
//  过渡动画-仿抖音点击视频
//
//  Created by 张崇超 on 2018/6/21.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 是否是弹出试图
    var isPresent: Bool = false
    // dismiss手势进度对象
    var animaionTool: UIPercentDrivenInteractiveTransition!

    // 原始位置
    var originalFrame: CGRect?
    // 展示的图片
    var showImg: UIImage?
    
    lazy var falseView: UIImageView = {
        let falseView = UIImageView()
        falseView.contentMode = .scaleAspectFit
        falseView.backgroundColor = UIColor.black

        return falseView
    }()
    
    // 执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.25
    }
    
    // 执行动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 容器
        let container = transitionContext.containerView
        // 即将显示/隐藏的试图
        let showView: UIView = self.isPresent ? (transitionContext.view(forKey: UITransitionContextViewKey.to)!): (transitionContext.view(forKey: UITransitionContextViewKey.from)!)
        showView.frame = UIScreen.main.bounds
        
        if self.isPresent {
            
            // 添加到容器并展示出
            container.addSubview(showView)
            showView.alpha = 0.0
            // 假的View
            self.falseView.alpha = 1.0
            self.falseView.frame = self.originalFrame ?? CGRect.zero
            self.falseView.image = self.showImg
            kWindow.addSubview(self.falseView)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.falseView.frame = UIScreen.main.bounds

            }) { (isOk) in
                
                showView.alpha = 1.0
                self.falseView.alpha = 0.0
                transitionContext.completeTransition(true)
            }
            
        } else {
            
            showView.alpha = 0.0
            self.falseView.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                
                self.falseView.frame = self.originalFrame!
                
            }) { (isOk) in
                
                self.falseView.alpha = 0.0
                self.falseView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}

/*
 let container = transitionContext.containerView
 if self.isPresent {
 
 // 即将展示的View
 let presntedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
 presntedView.frame = UIScreen.main.bounds
 // 容器
 container.addSubview(presntedView)
 
 presntedView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
 
 UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
 
 presntedView.transform = CGAffineTransform.identity
 
 }) { (isOk) in
 
 transitionContext.completeTransition(true)
 }
 
 } else {
 
 let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
 dismissView.frame = UIScreen.main.bounds
 
 container.addSubview(dismissView)
 
 dismissView.alpha = 1.0
 UIView.animate(withDuration: 0.3, animations: {
 
 dismissView.alpha = 0.0
 
 }) { (isOk) in
 
 transitionContext.completeTransition(true)
 }
 }
 */

extension PresentAnimation: UIViewControllerTransitioningDelegate {
    
    // 设置present/dismiss的动画对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresent = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresent = false
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return self.animaionTool
    }
    
}
