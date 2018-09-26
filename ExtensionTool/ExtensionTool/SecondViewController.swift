//
//  SecondViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: BaseViewController {

    var isLeftFront: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        self.showView.addSubview(self.centerView)
        self.showView.addSubview(self.rightView)
        self.showView.addSubview(self.leftView)

        self.view.addSubview(self.showView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       self.test1()
    }
    
    func test1() {

        self.leftView.layer.removeAnimation(forKey: "group1")
        self.rightView.layer.removeAnimation(forKey: "group2")

        let positionAni1 = CABasicAnimation(keyPath: "position")
        positionAni1.fromValue = NSValue(cgPoint: CGPoint(x: self.leftView.frame.origin.x + 10.0, y: 10.0))
        positionAni1.toValue = NSValue(cgPoint: CGPoint(x: self.leftView.frame.origin.x + 10.0 + 20.0, y: 10.0))
        let alphaAni1 = CABasicAnimation(keyPath: "opacity")
        alphaAni1.fromValue = NSNumber(value: 0.8)
        alphaAni1.toValue = NSNumber(value: 1.0)
        
        let scaleAni1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAni1.fromValue = NSNumber(value: 0.8)
        scaleAni1.toValue = NSNumber(value: 1.0)

        let group1 = CAAnimationGroup()
        group1.animations = [positionAni1, alphaAni1, scaleAni1]
        group1.duration = 2.0
        group1.repeatDuration = CFTimeInterval(MAXFLOAT)
        group1.autoreverses = true
        group1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        group1.isRemovedOnCompletion = false
        group1.fillMode = CAMediaTimingFillMode.forwards
        self.leftView.layer.add(group1, forKey: "group1")
        
        
        let positionAni2 = CABasicAnimation(keyPath: "position")
        positionAni2.fromValue = NSValue(cgPoint: CGPoint(x: self.rightView.frame.origin.x + 10.0, y: 10.0))
        positionAni2.toValue = NSValue(cgPoint: CGPoint(x: self.rightView.frame.origin.x + 10.0 - 20.0, y: 10.0))
        
        let alphaAni2 = CABasicAnimation(keyPath: "opacity")
        alphaAni2.fromValue = NSNumber(value: 1.0)
        alphaAni2.toValue = NSNumber(value: 0.8)
        
        let scaleAni2 = CABasicAnimation(keyPath: "transform.scale")
        scaleAni2.fromValue = NSNumber(value: 1.0)
        scaleAni2.toValue = NSNumber(value: 0.8)
        
        let group2 = CAAnimationGroup()
        group2.animations = [positionAni2, alphaAni2, scaleAni2]
        group2.duration = group1.duration
        group2.repeatDuration = group1.repeatDuration
        group2.autoreverses = group1.autoreverses
        group2.timingFunction = group1.timingFunction

        group2.isRemovedOnCompletion = group1.isRemovedOnCompletion
        group2.fillMode = group1.fillMode
        self.rightView.layer.add(group2, forKey: "group2")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    lazy var showView: UIView = {
        let view = UIView.init(frame: CGRect(x: (self.view.bounds.width - 100.0) / 2.0, y: (self.view.bounds.height - 100.0) / 2.0, width: 100.0, height: 100.0))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView.init(frame: CGRect(x:(self.showView.bounds.width - 20.0) / 2.0 - 12.0, y: 0.0, width: 20.0, height: 20.0))
        view.backgroundColor = UIColor.cyan
        view.cornerRadius = 10.0
        view.clipsToBounds = true
        
        return view
    }()
    lazy var rightView: UIView = {
        let view = UIView.init(frame: CGRect(x:(self.showView.bounds.width - 20.0) / 2.0 + 12.0, y: 0.0, width: 20.0, height: 20.0))
        view.backgroundColor = UIColor.red
        view.cornerRadius = 10.0
        view.clipsToBounds = true

        return view
    }()
    lazy var centerView: UIView = {
        let view = UIView.init(frame: CGRect(x:(self.showView.bounds.width - 20.0) / 2.0, y: 0.0, width: 20.0, height: 20.0))
        view.backgroundColor = UIColor.black
        view.cornerRadius = 10.0
        view.clipsToBounds = true
        
        return view
    }()
    
}


