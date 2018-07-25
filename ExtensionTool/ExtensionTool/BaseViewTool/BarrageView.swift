//
//  BarrageView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/25.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BarrageModel: NSObject {
    
    var text: String = ""
    var userId: String = ""
}

class BarrageView: UIView {
    
    /// 复用池
    private var cachesArr: [UILabel] = []
    /// 控件高度
    private let textHeight: CGFloat = 26.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchPoint = touch.location(in: self)
        
        for subView in self.subviews {
            
            let frame = subView.layer.presentation()!.frame
            if frame.contains(touchPoint) {
                
                print((subView as! UILabel).barrageModel.userId)
                break
            }
        }
    }
    
    func sendBarrage(model: BarrageModel) {
        
        let textWidth: CGFloat = model.text.k_textSize(size: CGSize(width: 9999.0, height: self.textHeight), font: UIFont.systemFont(ofSize: 15.0)).width + 10.0
        let width: CGFloat = max(textWidth, self.bounds.width)
        
        var textL: UILabel!
        if self.cachesArr.isEmpty {
            
            textL = UILabel.init(frame: CGRect.zero)
            textL.font = UIFont.systemFont(ofSize: 15.0)
            textL.textAlignment = .center
            
            self.addSubview(textL)
            print("开始创建:\(Date())")

        } else {
            
            textL = self.cachesArr.first!
            self.cachesArr.remove(at: 0)
        }
        textL.frame = CGRect.init(x: width, y: self.allRoteArr[Int.k_randomNum(to: self.allRoteArr.count)], width: textWidth, height: self.textHeight)
        
        textL.barrageModel = model
        textL.text = model.text
        textL.textColor = UIColor.k_randomColor
        
        weak var weakSelf = self
        var newFrame = textL.frame
        newFrame.origin.x = -width
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveLinear, .allowUserInteraction], animations: {
            
            textL.frame = newFrame
            
        }) { (isOK) in
            
            weakSelf?.cachesArr.append(textL)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 所有的轨道
    private lazy var allRoteArr: [CGFloat] = { [unowned self] in
        var arr: [CGFloat] = []
        var originalY: CGFloat = -self.textHeight
        while originalY < self.bounds.height {
            
            originalY += self.textHeight
            if originalY <= self.bounds.height - self.textHeight {
                arr.append(originalY)
            }
        }
        return arr
    }()

    deinit {
        
        print("\n====== \(self) 销毁了======\n")
    }
}

var kUILabelBarrageKey: Int = 0

extension UILabel {
    
    var barrageModel: BarrageModel {
        set {
            objc_setAssociatedObject(self, &kUILabelBarrageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { return objc_getAssociatedObject(self, &kUILabelBarrageKey) as! BarrageModel }
    }
}
