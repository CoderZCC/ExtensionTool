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
        
        self.view.backgroundColor = UIColor.k_colorWith(hexInt: 0x666666)
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

        let pushVC = SecondViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

class SecondViewController: BaseViewController {
    
    let input = UITextView.init(frame: CGRect(x: 30.0, y: 100.0, width: kWidth - 60.0, height: 200.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(input)
        
        self.view.addSubview(self.myInputView)
    }

    lazy var myInputView: BottomInputView5 = {
        let tool = BottomInputView5.initViewWith(self.input)
        tool.backgroundColor = UIColor.lightGray
        
        return tool
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
