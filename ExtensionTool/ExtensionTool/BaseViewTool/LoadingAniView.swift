//
//  LoadingAniView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/26.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

class LoadingAniView: UIView {
    
    class func startAnimation(frame: CGRect = CGRect(x: 0.0, y: UIScreen.main.bounds.height / 2.0, width: UIScreen.main.bounds.width, height: 200.0)) {
        
        if UIApplication.shared.keyWindow?.viewWithTag(989898) == nil {
            
            let showView = LoadingAniView(frame: frame)
            showView.backgroundColor = UIColor.darkGray
            showView.tag = 989898
            showView.addSubview(showView.leftView)
            showView.addSubview(showView.rightView)
            showView.addAniToView()
            
            UIApplication.shared.keyWindow?.addSubview(showView)
        }
    }
    
    class func stopAnimation() {
        
        if let showView = UIApplication.shared.keyWindow?.viewWithTag(989898) {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                showView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                showView.alpha = 0.0
                
            }) { (isOk) in
                
                for subView in showView.subviews {
                    
                    subView.layer.removeAllAnimations()
                    subView.removeFromSuperview()
                }
                showView.removeFromSuperview()
            }
        }
    }
    
    private func addAniToView() {
        
        self.leftView.layer.removeAnimation(forKey: "group1")
        self.rightView.layer.removeAnimation(forKey: "group2")
        
        let positionAni1 = CABasicAnimation(keyPath: "position")
        positionAni1.fromValue = NSValue(cgPoint: CGPoint(x: self.leftView.frame.origin.x + 10.0, y: 10.0))
        positionAni1.toValue = NSValue(cgPoint: CGPoint(x: self.leftView.frame.origin.x + 10.0 + 20.0, y: 10.0))
        
        let scaleAni1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAni1.fromValue = NSNumber(value: 0.8)
        scaleAni1.toValue = NSNumber(value: 1.0)
        
        let group1 = CAAnimationGroup()
        group1.animations = [positionAni1, scaleAni1]
        group1.duration = 0.5
        group1.repeatDuration = CFTimeInterval(MAXFLOAT)
        group1.autoreverses = true
        group1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        group1.isRemovedOnCompletion = false
        group1.fillMode = CAMediaTimingFillMode.forwards
        self.leftView.layer.add(group1, forKey: "group1")
        
        
        let positionAni2 = CABasicAnimation(keyPath: "position")
        positionAni2.fromValue = NSValue(cgPoint: CGPoint(x: self.rightView.frame.origin.x + 10.0, y: 10.0))
        positionAni2.toValue = NSValue(cgPoint: CGPoint(x: self.rightView.frame.origin.x + 10.0 - 20.0, y: 10.0))
        
        let scaleAni2 = CABasicAnimation(keyPath: "transform.scale")
        scaleAni2.fromValue = scaleAni1.toValue
        scaleAni2.toValue = scaleAni1.fromValue
        
        let group2 = CAAnimationGroup()
        group2.animations = [positionAni2, scaleAni2]
        
        group2.duration = group1.duration
        group2.repeatDuration = group1.repeatDuration
        group2.autoreverses = group1.autoreverses
        group2.timingFunction = group1.timingFunction
        
        group2.isRemovedOnCompletion = group1.isRemovedOnCompletion
        group2.fillMode = group1.fillMode
        self.rightView.layer.add(group2, forKey: "group2")
    }
    
    private lazy var leftView: UIView = {
        let view = UIView(frame: CGRect(x:(self.bounds.width - 20.0) / 2.0 - 12.0, y: 0.0, width: 20.0, height: 20.0))
        view.backgroundColor = UIColor.cyan
        view.cornerRadius = 10.0
        view.clipsToBounds = true
        
        return view
    }()
    private lazy var rightView: UIView = {
        let view = UIView(frame: CGRect(x:(self.bounds.width - 20.0) / 2.0 + 12.0, y: 0.0, width: 20.0, height: 20.0))
        view.backgroundColor = UIColor.red
        view.cornerRadius = 10.0
        view.clipsToBounds = true
        view.alpha = 0.7
        
        return view
    }()
}
