//
//  HorizontalLabelView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/24.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class HorizontalLabelView: UIView {
    
    /// 初始化控件
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - labelArr: 标签数组
    ///   - block: 回调
    init(frame: CGRect, labelArr: [String], block: ((Int)->Void)?) {
        super.init(frame: frame)
        
        self.labelArr = labelArr
        self.block = block
        self.addSubview(self.scrollView)
    }
    
    /// 点击回调
    private var block: ((Int)->Void)?
    /// 数据源
    private var labelArr: [String] = [] {
        willSet {
            
            // 总行数
            var totalRow: Int = 1
            var markBtn: UIButton!
            for (index, text) in newValue.enumerated() {
                
                let textWidth = self.textWidth(text: text, font: UIFont.systemFont(ofSize: 16.0)) + 20.0
                
                let labelBtn = UIButton.init(type: .custom)
                labelBtn.tag = index
                if markBtn == nil {
                    
                    labelBtn.frame = CGRect(x: self.marginX, y: self.marginY, width: textWidth, height: labelHeight)
                    
                } else {
                    
                    if markBtn.frame.origin.x + markBtn.frame.size.width + marginY + textWidth + marginX > self.maxWidth {
                       
                        // 换行
                        totalRow += 1
                        if Double(totalRow).truncatingRemainder(dividingBy: 2.0) == 0.0 {
                            
                            labelBtn.frame = CGRect(x: marginX + 20.0, y: markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width: textWidth, height: labelHeight)

                        } else {
                            
                            labelBtn.frame = CGRect(x: marginX, y: markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width: textWidth, height: labelHeight)
                        }
                        
                    } else {
                        
                        labelBtn.frame = CGRect(x: markBtn.frame.origin.x + markBtn.frame.size.width + marginX, y: markBtn.frame.origin.y, width: textWidth, height: labelHeight)
                    }
                }
                labelBtn.backgroundColor = UIColor.white
                labelBtn.layer.cornerRadius = 4.0
                labelBtn.clipsToBounds = true
                
                labelBtn.setTitle(text, for: .normal)
                labelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
                labelBtn.setTitleColor(UIColor.darkText, for: .normal)
                labelBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
           
                markBtn = labelBtn
                
                self.scrollView.addSubview(markBtn)
            }
            let totalHeight: CGFloat = markBtn.frame.origin.y + markBtn.frame.size.height + marginY
            var newFrame = self.frame
            newFrame.size.height = min(totalHeight, kHeight - kNavBarHeight)
            self.frame = newFrame
            
            self.scrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        }
    }
    /// 最大宽度 水平滑动
    private let maxWidth: CGFloat = kWidth * 2.0
    /// 横向间距
    private let marginX: CGFloat = 8.0
    /// 纵向间距
    private let marginY: CGFloat = 8.0
    /// 一个标签的高度
    private let labelHeight: CGFloat = 30.0
    
    private func textWidth(text: String, font: UIFont) -> CGFloat {
        let str = NSString.init(string: text)
        let rect = str.boundingRect(with: CGSize.init(width: kWidth - 20.0, height: self.labelHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return rect.size.width
    }
    @objc private func btnAction(btn: UIButton) {
        
        self.block?(btn.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addSubview(self.scrollView)
    }
    
    deinit {
        print("###\(self)销毁了###\n")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.alwaysBounceHorizontal = true
        scrollView.contentSize = CGSize(width: self.maxWidth, height: self.bounds.height)
    
        return scrollView
    }()
}
