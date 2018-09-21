//
//  AlertTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/21.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class AlertTool: UIView {

    /// 控件宽度
    private let showWidth: CGFloat = UIScreen.main.bounds.width - 100.0
    /// 两个按钮间的距离
    private let btnSpace: CGFloat = 30.0
    /// 按钮距离左右两边的距离
    private let btnMarginAtLeft: CGFloat = 15.0
    /// 按钮高度
    private let btnHeight: CGFloat = 35.0
    /// 按钮距离底部的间隔
    private let btnMarginAtBootom: CGFloat = 15.0
    
    //MARK: -标题内容
    /// 标题距离顶部的距离
    private let titleMarginAtTop: CGFloat = 20.0
    /// 文字距离左侧的距离
    private let textMarginAtLeft: CGFloat = 15.0
    /// 内容和标题的间隔
    private let contentSpaceWithTitle: CGFloat = 8.0
    /// 内容和按钮的间隔
    private let contentSpaceWithBtn: CGFloat = 8.0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(title: String? = "提示", content: String? = nil, leftText: String = "取消", rightText: String = "确定", leftAction: (()->Void)?, rightAction: (()->Void)?) {
        
        self.leftBtn.setTitle(leftText, for: .normal)
        self.rightBtn.setTitle(rightText, for: .normal)
        
        self.leftAction = leftAction
        self.leftAction = rightAction
    }
    
    func hidenAlert() {
        
        
    }
    
    private var leftAction: (()->Void)?
    private var rightAction: (()->Void)?

    /// 按钮宽度
    private lazy var btnWidth: CGFloat = {
        
        return (self.showWidth - self.btnSpace - self.btnMarginAtLeft * 2.0) / 2.0
    }()
    
    private lazy var showView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.showWidth, height: 0.0))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var titleL: UILabel = {
        let label = UILabel(frame: CGRect(x: self.textMarginAtLeft, y: self.titleMarginAtTop, width: self.showWidth - self.textMarginAtLeft * 2.0, height: 20.0))
        label.textAlignment = .center

        return label
    }()
    private lazy var contentL: UILabel = {
        let label = UILabel(frame: CGRect(x: self.textMarginAtLeft, y: self.titleL.frame.maxY + self.contentSpaceWithTitle, width: self.showWidth - self.textMarginAtLeft * 2.0, height: 20.0))
        label.textAlignment = .left

        return label
    }()
    
    private lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: self.btnMarginAtLeft, y: self.contentL.frame.maxY + self.contentSpaceWithBtn - self.btnHeight, width: self.btnWidth, height: self.btnHeight)
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.k_addTarget { [unowned self] in
        
            self.leftAction?()
            self.hidenAlert()
        }
        
        return btn
    }()
    private lazy var rightBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: self.showWidth - self.btnMarginAtLeft - self.btnWidth, y: self.leftBtn.frame.minY, width: self.leftBtn.bounds.width, height: self.btnHeight)
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.k_addTarget { [unowned self] in
            
            self.rightAction?()
            self.hidenAlert()
        }
        
        return btn
    }()
    
}
