//
//  AlertSheetTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/21.
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tag = 940425
        self.alpha = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
        
        self.showView.transform = CGAffineTransform(translationX: 0.0, y: self.bounds.height)
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 1.0
            self.showView.transform = CGAffineTransform.identity

        }) { (isOk) in
            
            
        }        
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
