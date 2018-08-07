//
//  DownLoadViewTool.swift
//  VideoClipDemo
//
//  Created by 张崇超 on 2018/6/8.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class DownLoadViewTool: UIView {
    
    static var selfInit: DownLoadViewTool = DownLoadViewTool.init(frame: CGRect.init(x: (kWidth - 110.0) / 2.0, y: (kHeight - 110.0) / 2.0, width: 110.0, height: 110.0))
    
    var beginAngle: CGFloat = CGFloat.pi * 3.0 / 2.0
    var finishAngle: CGFloat = CGFloat.pi * 3.0 / 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.frame.height / 2.0
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        
        let tool = DownLoadViewTool.selfInit
        tool.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        let color = UIColor.white
        color.set()
        
        let aPath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: 50.0, startAngle: beginAngle, endAngle: finishAngle, clockwise: true)
        aPath.addLine(to: CGPoint.init(x: self.frame.width / 2.0, y: self.frame.height / 2.0))
        aPath.close()
        aPath.fill()
        
        finishAngle += CGFloat.pi / 20.0
        if finishAngle > beginAngle + CGFloat.pi * 2.0 {
            
            print("结束")
            finishAngle = CGFloat.pi * 3.0 / 2.0
        }
    }
}
