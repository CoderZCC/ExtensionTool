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

        self.view.addSubview(self.textField)
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let secondVC = SecondViewController()
//        self.navigationController?.pushViewController(secondVC, animated: true)
//    }
    lazy var textField: UITextView = {
        let tf = UITextView.init(frame: CGRect(x: 20.0, y: 100.0, width: kWidth - 40.0, height: 35.0))
        tf.placeholder = "输入文字"
        tf.backgroundColor = UIColor.white
        tf.k_limitTextLength = 5
        
        return tf
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

