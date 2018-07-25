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

        self.view.addSubview(self.ad)
    }

    lazy var ad: HorizontalADView = {
        let tool = HorizontalADView.init(frame: CGRect.init(x: 0.0, y: kNavBarHeight, width: kWidth, height: 260.0), imgUrlArr: ["1", "2", "3", "4"], block: { (index) in
            
            
        })
        
        return tool
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

