//
//  SpecialView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/26.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class SpecialView: UIView {

    /// 展示底部弹窗
    ///
    /// - Parameter baseView: 父视图
    class func showSpecialView(baseView: UIView? = nil, block:((Int)->Void)?) {
        
        let fatherView = (baseView ?? kWindow)
        if let _ = SpecialView.currentTool { return }
        
        let tool = SpecialView.loadXibView()
        tool.alpha = 0.0
        tool.block = block
        fatherView.addSubview(tool)
        SpecialView.currentTool = tool

        tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)

        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.showView.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
        }
    }
    
    /// 隐藏底部弹窗
    class func hiddenSpecialView() {
        
        guard let tool = SpecialView.currentTool else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            tool.alpha = 0.0
            tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)
            
        }) { (isOK) in
            
            tool.removeFromSuperview()
            SpecialView.currentTool = nil
        }
    }
    
    /// 数据源
    private let textArr: [String] = ["回复", "转发"]
    /// 展示控件的父视图
    @IBOutlet private weak var showView: UIView!
    /// 表视图
    @IBOutlet private weak var tableView: UITableView!
    /// 表视图高度约束
    @IBOutlet private weak var tableViewHeightCons: NSLayoutConstraint!
    /// 点击回调
    private var block:((Int)->Void)?
    /// 当前活跃的对象
    private static var currentTool: SpecialView?
    
    /// 从xib加载
    private class func loadXibView() -> SpecialView {
        let tool = Bundle.main.loadNibNamed("SpecialView", owner: nil, options: nil)?.first as! SpecialView
        tool.frame = UIScreen.main.bounds

        return tool
    }
    
    /// 按钮点击事件
    @IBAction func btnAction() {
        
        SpecialView.hiddenSpecialView()
    }
    
    //MARK: -Overwrite
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 49.0
        self.tableViewHeightCons.constant = self.tableView.rowHeight * CGFloat(self.textArr.count)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.btnAction()
    }
    
    deinit {
        print("###\(NSStringFromClass(SpecialView.self))销毁了###\n")
    }
}

extension SpecialView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.btnAction()
        self.block?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SpecialView")
        if cell == nil {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "SpecialView")
            cell?.backgroundColor = tableView.backgroundColor
            cell?.textLabel?.textAlignment = .center
            cell?.selectionStyle = .none
            cell?.separatorInset = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
        }
        cell?.textLabel?.text = self.textArr[indexPath.row]
        
        return cell!
    }
}

