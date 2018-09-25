//
//  AlertTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/25.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 展示底部弹窗
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - textArr: 数组
    ///   - block: 回调
    func showSheet(title: String? = nil, textArr: [String], block:((Int)->Void)?) {
        
        if Thread.isMainThread {
            
            if !AlertSheetTool.isShowAlearly {
                
                let tool = AlertSheetTool(frame: UIScreen.main.bounds)
                tool.showSheet(title, textArr: textArr, block: block)
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showSheet(title: title, textArr: textArr, block: block)
            }
        }
    }
    
    /// 展示确定取消框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - leftText: 左按钮文字
    ///   - rightText: 右按钮文字
    ///   - leftAction: 左按钮事件
    ///   - rightAction: 右按钮事件
    func showAlert(title: String? = nil, content: String? = nil, leftText: String = "取消", rightText: String = "确定", leftAction: (()->Void)? = nil, rightAction: (()->Void)? = nil) {
        
        if Thread.isMainThread {
            
            if !AlertViewTool.isShowAlearly {
                
                let tool: AlertViewTool = AlertViewTool(frame: UIScreen.main.bounds)
                tool.showAlet(title: title, content: content, leftText: leftText, rightText: rightText, leftAction: leftAction, rightAction: rightAction)
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.showAlert(title: title, content: content, leftText: leftText, rightText: rightText, leftAction: leftAction, rightAction: rightAction)
            }
        }
    }
}

class AlertSheetTool: UIView {
    
    /// 是否已经展示了
    static var isShowAlearly: Bool {
        
        return UIApplication.shared.keyWindow!.viewWithTag(940425) != nil
    }
    
    /// 一行文字的高度
    private let signleHeight: CGFloat = 44.0
    /// 取消按钮高度
    private let cancleHeight: CGFloat = 44.0
    /// 间隔高度
    private let spaceHeight: CGFloat = 6.0
    /// iPhoneX底部高度
    private let bottomHeight: CGFloat = kBottomSpace
    /// 间隔背景颜色
    private let spaceColor: UIColor = UIColor.lightGray
    /// 标题大小 颜色
    private let titleFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    private let titleColor: UIColor = UIColor.black
    /// 选择文字大小 颜色
    private let textFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    private let textColor: UIColor = UIColor.darkGray
    /// 取消按钮大小 颜色
    private let cancleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    private let cancleColor: UIColor = UIColor.darkGray
    /// 蒙版颜色
    private let maskColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tag = 940425
        self.alpha = 0.0
        self.backgroundColor = self.maskColor
        self.showView.transform = CGAffineTransform(translationX: 0.0, y: self.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 展示选择试图
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - textArr: 选择数组
    ///   - block: 选择下标
    func showSheet(_ title: String? = nil, textArr: [String], block: ((Int)->Void)?) {
        
        self.textArr = textArr
        self.block = block
        
        if let title = title {
            
            self.isTitle = true
            self.textArr.insert(title, at: 0)
        }
        // 添加控件
        let tabHeight = CGFloat(self.textArr.count) * self.signleHeight
        let allHeight = tabHeight + self.bottomHeight + self.spaceHeight
        self.showView.frame = CGRect(x: 0.0, y: self.frame.maxY - allHeight - self.bottomHeight, width: self.bounds.width, height: allHeight)
        
        self.addSubview(self.showView)
        self.tableView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: tabHeight)
        self.showView.addSubview(self.tableView)
        self.showView.addSubview(self.cancleView)
        self.showView.addSubview(self.safeAreaView)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 1.0
            self.showView.transform = CGAffineTransform.identity
        })
    }
    
    func hideSheet() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform(translationX: 0.0, y: self.bounds.height)
            
        }) { (isOk) in
            
            self.showView.removeFromSuperview()
            self.tableView.removeFromSuperview()
            self.cancleView.removeFromSuperview()
            self.safeAreaView.removeFromSuperview()
            
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.hideSheet()
    }
    
    private var textArr: [String]!
    private var block: ((Int)->Void)?
    /// 是否有标题
    private var isTitle: Bool = false
    
    private lazy var showView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 0.0))
        view.backgroundColor = self.spaceColor
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = self.signleHeight
        
        return tableView
    }()
    
    private lazy var cancleView: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.system)
        btn.frame = CGRect(x: 0.0, y: self.tableView.frame.maxY + self.spaceHeight, width: self.bounds.width, height: self.cancleHeight)
        btn.backgroundColor = UIColor.white
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(self.cancleColor, for: .normal)
        btn.titleLabel?.font = self.cancleFont
        btn.k_addTarget { [unowned self] in
            
            self.hideSheet()
        }
        
        return btn
    }()
    private lazy var safeAreaView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.cancleView.frame.maxY, width: self.bounds.width, height: self.bottomHeight))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    deinit {
        debugPrint("-- \(self)销毁了 --")
    }
}

extension AlertSheetTool: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.hideSheet()
        if self.isTitle {
            
            if indexPath.row == 0 { return }
            self.block?(indexPath.row - 1)
            
        } else {
            
            self.block?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlertSheetTool")
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "AlertSheetTool")
            cell?.textLabel?.textAlignment = .center
            cell?.selectionStyle = .none
            
            cell?.textLabel?.font = self.textFont
            cell?.textLabel?.textColor = self.textColor
        }
        cell?.textLabel?.text = self.textArr[indexPath.row]
        if self.isTitle {
            
            if indexPath.row == 0 {
                
                cell?.textLabel?.font = self.titleFont
                cell?.textLabel?.textColor = self.titleColor
                
            } else {
                
                cell?.textLabel?.font = self.textFont
                cell?.textLabel?.textColor = self.textColor
            }
        }
        
        return cell!
    }
}

class AlertViewTool: UIView {
    
    /// 是否已经展示了
    static var isShowAlearly: Bool {
        
        return UIApplication.shared.keyWindow!.viewWithTag(950412) != nil
    }
    /// 控件宽度
    private let showWidth: CGFloat = UIScreen.main.bounds.width - 100.0
    /// 两个按钮间的距离
    private let btnSpace: CGFloat = 30.0
    /// 按钮距离左右两边的距离
    private let btnMarginAtLeft: CGFloat = 15.0
    /// 按钮高度
    private let btnHeight: CGFloat = 35.0
    /// 按钮距离底部的间隔
    private let btnMarginAtBottom: CGFloat = 15.0
    
    //MARK: -标题内容
    /// 标题字体
    private let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
    /// 内容字体
    private let contentFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 标题距离顶部的距离
    private let titleMarginAtTop: CGFloat = 15.0
    /// 文字距离左侧的距离
    private let textMarginAtLeft: CGFloat = 15.0
    /// 内容和标题的间隔
    private let contentSpaceWithTitle: CGFloat = 8.0
    /// 内容和按钮的间隔
    private let contentSpaceWithBtn: CGFloat = 10.0
    /// 蒙版颜色
    private let maskColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tag = 950412
        self.alpha = 0.0
        self.backgroundColor = self.maskColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 展示
    func showAlet(title: String? = nil, content: String? = nil, leftText: String = "取消", rightText: String = "确定", leftAction: (()->Void)? = nil, rightAction: (()->Void)? = nil) {
        
        self.addSubview(self.showView)
        // 标题高度
        if let title = title {
            
            self.titleL.text = title
            var newFrame = self.titleL.frame
            newFrame.size.height = self.textHeight(text: title, font: self.titleFont)
            self.titleL.frame = newFrame
            
            self.showView.addSubview(self.titleL)
        }
        // 内容高度
        if let content = content {
            
            let contentTopMargin = title == nil ? (0.0) : (self.titleL.frame.maxY)
            self.contentL.frame = CGRect(x: self.textMarginAtLeft, y: contentTopMargin + self.contentSpaceWithTitle, width: self.showWidth - self.textMarginAtLeft * 2.0, height: self.textHeight(text: content, font: self.contentFont))
            self.contentL.text = content
            self.showView.addSubview(self.contentL)
        }
        // 按钮位置计算
        let btnTopMargin = content == nil ? (self.titleL.frame.maxY) : (self.contentL.frame.maxY)
        self.leftBtn.frame = CGRect(x: self.btnMarginAtLeft, y: btnTopMargin + self.contentSpaceWithBtn, width: self.btnWidth, height: self.btnHeight)
        self.leftBtn.setTitle(leftText, for: .normal)
        self.rightBtn.setTitle(rightText, for: .normal)
        self.leftAction = leftAction
        self.leftAction = rightAction
        self.showView.addSubview(self.leftBtn)
        self.showView.addSubview(self.rightBtn)
        // 父视图尺寸计算
        self.showView.frame = CGRect(x: 0.0, y: 0.0, width: self.showWidth, height: self.leftBtn.frame.maxY + self.btnMarginAtBottom)
        self.showView.center = self.center
        // 执行动画
        self.showView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25, delay: 0/0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            self.alpha = 1.0
            self.showView.transform = CGAffineTransform.identity
        })
    }
    
    /// 隐藏
    func hidenAlert() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }) { (isOk) in
            
            self.titleL.removeFromSuperview()
            self.contentL.removeFromSuperview()
            self.leftBtn.removeFromSuperview()
            self.rightBtn.removeFromSuperview()
            
            self.removeFromSuperview()
        }
    }
    
    private var leftAction: (()->Void)?
    private var rightAction: (()->Void)?
    
    /// 计算文字高度
    private func textHeight(text: String, font: UIFont) -> CGFloat {
        let rect = NSString(string: text).boundingRect(with: CGSize(width: self.showWidth - self.textMarginAtLeft * 2.0, height: 100.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return rect.size.height + 5.0
    }
    
    /// 按钮宽度
    private lazy var btnWidth: CGFloat = {
        
        return (self.showWidth - self.btnSpace - self.btnMarginAtLeft * 2.0) / 2.0
    }()
    
    private lazy var showView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.cornerRadius = 5.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleL: UILabel = {
        let label = UILabel(frame: CGRect(x: self.textMarginAtLeft, y: self.titleMarginAtTop, width: self.showWidth - self.textMarginAtLeft * 2.0, height: 0.0))
        label.textAlignment = .center
        label.font = self.titleFont
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var contentL: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .left
        label.font = self.contentFont
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.cornerRadius = 3.0
        btn.clipsToBounds = true
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
        btn.cornerRadius = 3.0
        btn.clipsToBounds = true
        btn.k_addTarget { [unowned self] in
            
            self.rightAction?()
            self.hidenAlert()
        }
        
        return btn
    }()
    
    deinit {
        debugPrint("-- \(self)销毁了 --")
    }
}
