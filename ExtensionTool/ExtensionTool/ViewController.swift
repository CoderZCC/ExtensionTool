//
//  ViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("###\(self)销毁了###\n")
    }
}

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

