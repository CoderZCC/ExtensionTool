//
//  ViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)
        
    }

    lazy var pushVC: UIViewController = {
        let cls = self.k_getClassFrom("SecondViewController")!
        let pushVC: UIViewController = cls.init()
        pushVC.k_setValueToProperty(cls: cls, dataDic: ["name": "ZCC", "aaa": "aaa"])

        return pushVC
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.navigationController?.pushViewController(self.pushVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class SecondViewController: UIViewController {
    
    @objc var name: String = ""
    @objc var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        print("name:\(self.name)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
