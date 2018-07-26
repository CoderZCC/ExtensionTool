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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tool)
    }
    
    lazy var tool: CalendarView = {
        let tool = CalendarView.showCalendarWith(frame: CGRect.init(x: 0.0, y: kNavBarHeight, width: kWidth, height: 300.0), block: { (str) in
            
            print(str)
        })
        tool.setStateSelected(with: [Date(), Date().k_addingHours(-24), Date().k_addingHours(-24 * 3)])
        
        return tool
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

