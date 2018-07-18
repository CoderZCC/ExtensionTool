//
//  UITableView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// 隐藏多余的线
    func k_hiddeLine() {
        
        self.tableFooterView = UIView()
    }
}
