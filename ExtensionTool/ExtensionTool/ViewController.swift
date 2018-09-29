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
        
        /*
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        */
        
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)
        self.k_setupMyNavBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        debugPrint("###\(self)销毁了###\n")
    }
}

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var str: String = ""
    @IBAction func btnAction() {

        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

