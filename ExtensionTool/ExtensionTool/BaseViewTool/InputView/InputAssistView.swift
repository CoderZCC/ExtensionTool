//
//  InputAssistView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/27.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class InputAssistView: UIView {

    /// 初始化工具
    ///
    /// - Parameters:
    ///   - textField: 输入框
    ///   - textList: 数据源
    ///   - block: 回调
    class func createWith(textField: UITextField, textList: [String]?, block: ((String)->Void)?) {
        
        guard let list = textList else {
            
            InputAssistView.destory()
            return
        }
        // 添加到试图
        if InputAssistView.instanced == nil {
            
            let tool = InputAssistView.init(frame: UIScreen.main.bounds)
            tool.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            tool.block = block
            tool.textField = textField
            InputAssistView.instanced = tool
            
            tool.faterView.insertSubview(tool, belowSubview: textField)
        }
        // 数据传递
        InputAssistView.instanced?.dataList = list
        InputAssistView.instanced?.tableView.reloadData()
        
        // 更新UI
        var newFrame = InputAssistView.instanced!.tableView.frame
        newFrame.size.height = min(InputAssistView.instanced!.maxViewHeight, CGFloat(list.count) * InputAssistView.instanced!.rowHeight)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            InputAssistView.instanced?.tableView.frame = newFrame
        })
    }
    
    /// 销毁工具
    class func destory() {
        
        guard let tool = InputAssistView.instanced else { return }
        var newFrame = tool.tableView.frame
        newFrame.size.height = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            
            tool.tableView.frame = newFrame
            
        }) { (isOK) in
            
            tool.removeFromSuperview()
            InputAssistView.instanced = nil
        }
    }

    /// 输入框
    private var textField: UITextField!
    /// 数据源
    private var dataList: [String]!
    /// 单元格高度
    private let rowHeight: CGFloat = 44.0
    /// 点击回调
    private var block: ((String)->Void)?
    private static var instanced: InputAssistView?
    
    //MARK: -Override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        InputAssistView.destory()
    }
    deinit {
        print("###\(self)销毁了###\n")
    }
    
    //MARK: -Lazy
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: self.tfFrame.maxY + 1.0, width: self.bounds.width, height: 0.0))
        tableView.tableFooterView = UIView()
        tableView.rowHeight = self.rowHeight
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsMake(0.0, self.tfFrame.origin.x, 0.0, 0.0)

        self.addSubview(tableView)
        return tableView
    }()
    /// 父视图
    private lazy var faterView: UIView = {
        
        return self.k_currentVC.view
    }()
    /// 输入框的位置
    private lazy var tfFrame: CGRect = {
        
        return self.convert(textField.frame, to: self.faterView)
    }()
    /// 最大高度
    private lazy var maxViewHeight: CGFloat = {
        
        return kHeight - self.tfFrame.maxY - 260.0
    }()
}
extension InputAssistView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        InputAssistView.destory()
        self.block?(self.dataList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "InputAssistView")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "InputAssistView")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = self.dataList[indexPath.row]
        
        return cell!
    }
}
