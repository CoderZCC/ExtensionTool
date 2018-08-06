//
//  CircleView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    /// 当前进度
    var progress: CGFloat = 0.0 {
        willSet {
            
            if self.showView.transform != CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0) {
                
                self.showView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
                self.moveView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
                self.shapeView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2.0 * 0.0 + CGFloat.pi / 2.0)
            }
            if (self.lastValue ?? 0.0) <= 1.0 {

                /// 线条动画
                self.redLineAnimation(value: newValue)
                /// 图片动画
                self.imgVAnimation(value: newValue)
                /// 三角动画
                self.shapeAnimation(value: newValue)
                /// 记录上一次动画位置
                self.lastValue = newValue
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSubViews()
    }
    
    /// 动画时长
    private var aniDuration: CFTimeInterval = 0.5
    /// 控件宽高
    private var showWidth: CGFloat = 140.0
    /// 上一次动画的位置
    private var lastValue: CGFloat?
    
    /// 初始化子视图
    private func initSubViews() {
        
        self.addSubview(self.showView)
        self.addSubview(self.centerImgV)
        self.showView.layer.addSublayer(self.grayLayer)
        self.showView.layer.addSublayer(self.redLayer)
        
        self.showView.addSubview(self.shapeView)
        self.showView.addSubview(self.moveView)
        self.moveView.addSubview(self.moveImgV)
    }
   
    /// 线条动画
    private func redLineAnimation(value: CGFloat) {
        
        self.redLayer.removeAnimation(forKey: "lineAni")
        
        if let value = self.lastValue, value >= 1.0 {
            
            // 位置重置
            self.lastValue = 0.0
        }
        let lineAni = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAni.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        lineAni.fillMode = kCAFillModeForwards
        lineAni.isRemovedOnCompletion = false
        lineAni.fromValue = NSNumber.init(value: Float((self.lastValue ?? 0.0)))
        lineAni.toValue = NSNumber.init(value: Float(value))

        lineAni.duration = self.aniDuration

        self.redLayer.add(lineAni, forKey: "lineAni")
    }
    /// 图片动画
    private func imgVAnimation(value: CGFloat) {
    
        self.moveView.layer.removeAnimation(forKey: "ani")
        
        let path = UIBezierPath.init(arcCenter: CGPoint(x: self.showView.k_width / 2.0, y: self.showView.k_height / 2.0), radius: self.showView.k_width / 2.0, startAngle: CGFloat.pi * 2.0 * (self.lastValue ?? 0.0) , endAngle: CGFloat.pi * 2.0 * value, clockwise: true)
        
        let ani = CAKeyframeAnimation.init(keyPath: "position")
        ani.path = path.cgPath
        ani.fillMode = kCAFillModeForwards
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.duration = self.aniDuration
        
        self.moveView.layer.add(ani, forKey: "ani")
    }
    
    /// 三角动画
    private func shapeAnimation(value: CGFloat) {
        
        self.shapeView.layer.removeAnimation(forKey: "ani")
        
        let path = UIBezierPath.init(arcCenter: CGPoint(x: self.showView.k_width / 2.0, y: self.showView.k_height / 2.0), radius: self.showView.k_width / 2.0 - self.moveView.k_width / 2.0, startAngle: CGFloat.pi * 2.0 * (self.lastValue ?? 0.0) , endAngle: CGFloat.pi * 2.0 * value, clockwise: true)
        
        let ani = CAKeyframeAnimation.init(keyPath: "position")
        ani.path = path.cgPath
        ani.fillMode = kCAFillModeForwards
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.duration = self.aniDuration
        
        self.shapeView.layer.add(ani, forKey: "ani")
        
        UIView.animate(withDuration: self.aniDuration) {
            
            self.shapeView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2.0 * value + CGFloat.pi / 2.0)
        }
    }
    
    // MARK: -Lazy
    /// 移动的视图
    private lazy var moveView: UIView = {
        let viewWH: CGFloat = 40.0
        let view = UIView.init(frame: CGRect(x: (self.showView.k_width - viewWH) / 2.0, y: -viewWH / 2.0, width: viewWH, height: viewWH))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
       
        return view
    }()
    /// 等级图片
    private lazy var moveImgV: UIImageView = {
        let imgVWH: CGFloat = 30.0
        let imgV = UIImageView.init(frame: CGRect(x: (self.moveView.k_width - imgVWH) / 2.0, y: (self.moveView.k_height - imgVWH) / 2.0, width: imgVWH, height: imgVWH))
        imgV.k_setCircleImgV()
        imgV.image = #imageLiteral(resourceName: "vip")
        
        return imgV
    }()
    /// 三角试图
    lazy var shapeView: UIView = {
        let viewW: CGFloat = 20.0
        let viewH: CGFloat = 20.0
        let view = UIView(frame: CGRect(x: (self.showView.k_width - viewW) / 2.0, y: viewH / 2.0, width: viewW, height: viewH))
        view.addSubview(self.shapeImgV)

        return view
    }()
    lazy var shapeImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 5.0, y: 2.0, width: 10.0, height: 10.0))
        imgV.image = #imageLiteral(resourceName: "shape")
        imgV.contentMode = .scaleAspectFill

        return imgV
    }()
    
    /// 圆环父视图
    private lazy var showView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.showWidth, height: self.showWidth))
        view.center = self.center
        view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        
        return view
    }()
    /// 圆环路径
    private lazy var circlePath: UIBezierPath = {
        let path = UIBezierPath.init(ovalIn: CGRect(x: 0.0, y: 0.0, width: self.showView.k_width, height: self.showView.k_height))
        
        return path
    }()
    /// 红色圆环
    private lazy var redLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.path = self.circlePath.cgPath
        layer.lineWidth = 2.0
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }()
    /// 灰色圆环
    private lazy var grayLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.path = self.circlePath.cgPath
        layer.lineWidth = 2.0
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }()
    /// 中间图片
    private lazy var centerImgV: UIImageView = {
        let wh: CGFloat = self.showWidth - 40.0
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: wh, height: wh))
        imgV.k_setCircleImgV()
        imgV.image = #imageLiteral(resourceName: "center")
        imgV.center = self.center
        
        return imgV
    }()
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}
