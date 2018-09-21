//
//  AlertSheetTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/24.
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
    func showAlertSheet(title: String? = nil, textArr: [String], block:((Int)->Void)?) {
        
        AlertSheetTool.showAlertSheet(title: title, subTitleArr: textArr) { (index) in
            
            block?(index)
        }
    }
}

class AlertSheetTool: UIView {
    
    ///标题
    var titleText = ""
    ///是否正在运行
    var isRunning:Bool = false
    ///子标题数组
    var subTitleArr:Array<String> = []
    ///回调
    var subTitleClick:(Int)->Void = {_ in }
    ///单元格标记符
    static let identifier = "kAlertSheetCell"
    ///表视图
    var tableView:UITableView?
    
    ///单例
    static let sharedManager: AlertSheetTool = {
        
        let tool = AlertSheetTool()
        tool.frame = CGRect(x:0 , y: 0 ,width: kWidth ,height: kHeight)
        tool.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        tool.alpha = 0.0
        
        return tool
    }()
    
    static func showAlertSheet(title:String? , subTitleArr:Array<String>? , clickAction:@escaping (Int)->Void)
    {
        let tool = AlertSheetTool.sharedManager
        if tool.isRunning {
            
            //正在运行,结束运行
            return
        }
        tool.isRunning = true
        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)
        
        //赋值
        if let title = title {
            tool.titleText = title
        }
        tool.subTitleClick = clickAction
        if let subTitleArr = subTitleArr {
            
            tool.subTitleArr = subTitleArr
        }
        
        if let tableView = tool.tableView {
            
            tableView.removeFromSuperview()
        }
        tool.createTableView()
        tool.addSubview(tool.tableView!)
        tool.tableView!.reloadData()
        
        //展示View
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.tableView!.transform = CGAffineTransform.identity
            
        }){ (isOK) in
            
            tool.isRunning = false
        }
    }
    
    //触摸消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        cancleAction(isNeed: false)
    }
    //MARK:点击事件
    @objc func clickAction() -> Void {
        
        cancleAction(isNeed: false)
    }
    
    ///消失方法
    func cancleAction(isNeed:Bool) -> Void {
        
        let tool = AlertSheetTool.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        UIView.animate(withDuration: 0.4, animations: {
            
            tool.alpha = 0.0
            tool.tableView!.transform = CGAffineTransform.init(translationX: 0, y: kHeight)
            
        }) { (isOk) in
            
            tool.isRunning = false
            tool.removeFromSuperview()
            if isNeed {
                
                self.subTitleClick(self.subTitleArr.count)
            }
        }
    }
    
    //创建表视图
    func createTableView() {
        
        let bottomSpace: CGFloat = ((kHeight == 812) ? 34.0 : 0.0)
        let cellHeight:CGFloat = 44.0
        let footHeight:CGFloat = 55.0
        var height:CGFloat = cellHeight * CGFloat(self.subTitleArr.count) + bottomSpace
        
        //取消按钮的位置
        height += footHeight
        
        //是否有标题
        if !self.titleText.isEmpty
        {
            height += 49.0
        }
        
        let tableView = UITableView.init(frame: CGRect(x:0.0 , y: Double(kHeight - height) ,width: Double(kWidth) , height: Double(height)), style: UITableView.Style.plain)
        
        tableView.transform = CGAffineTransform.init(translationX: 0, y: kHeight)
        
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(cellHeight)
        tableView.sectionHeaderHeight = 0.0001
        tableView.sectionFooterHeight = 100
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //头视图
        if !self.titleText.isEmpty
        {
            let headL = UILabel.init(frame: CGRect(x:10 , y: 0, width:kWidth - 20 ,height:49))
            headL.text = self.titleText
            headL.textAlignment = NSTextAlignment.center
            headL.numberOfLines = 3
            headL.font = UIFont.systemFont(ofSize: 16.0)
            headL.textColor = UIColor.black
            
            //添加边框
            let layer = CALayer()
            let y = headL.frame.size.height - 0.5
            layer.frame = CGRect(x: 8, y: y ,width: kWidth - 16 ,height: 0.5)
            layer.backgroundColor = UIColor.black.cgColor
            headL.layer.addSublayer(layer)
            
            tableView.tableHeaderView = headL
        }
        
        //尾试图
        let footView:UIView = UIView.init(frame: CGRect(x:0.0 , y: 0.0 ,width:Double(kWidth) ,height : Double(footHeight)))
        footView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let footBtn = UIButton(type: UIButton.ButtonType.custom)
        footBtn.frame = CGRect(x: 0.0 , y: 6.0 , width: Double(kWidth) ,height: Double(footHeight))
        footBtn.backgroundColor = UIColor.white
        footBtn.setTitle("取消", for: UIControl.State.normal)
        footBtn.addTarget(self, action: #selector(AlertSheetTool.clickAction), for: UIControl.Event.touchUpInside)
        footBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        footView.addSubview(footBtn)
        tableView.tableFooterView = footView
        
        let tool = AlertSheetTool.sharedManager
        tool.tableView = tableView
    }
}

extension AlertSheetTool: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击事件
        subTitleClick(indexPath.row)
        cancleAction(isNeed: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.subTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: AlertSheetTool.identifier)
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: AlertSheetTool.identifier)
            cell?.textLabel?.textAlignment = NSTextAlignment.center
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        cell?.textLabel?.text = subTitleArr[indexPath.row]
        
        return cell!
    }
}

