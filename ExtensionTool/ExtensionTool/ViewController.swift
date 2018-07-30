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
        
        self.view.k_tapDismissKeyboard()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.myInputView)
    }
    
    lazy var myInputView: BottomInputView1 = {
        let view = BottomInputView1.init(frame: CGRect(x: 0.0, y: kHeight - 44.0 - kBottomSpace, width: kWidth, height: 44.0))
        view.backgroundColor = UIColor.lightGray
        view.textCallBack = { str in
            
            print(str)
        }
        view.placeHolder = "输入文字吧"
        
        return view
    }()
    
    deinit {

        self.myInputView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
