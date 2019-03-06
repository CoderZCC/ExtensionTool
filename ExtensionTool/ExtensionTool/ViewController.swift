//
//  ViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var title_locailedStr: String? {
        willSet {
            
            self.k_title = newValue?.localiedStr
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        PickerTool.showDatePicker(with: UIDatePicker.Mode.dateAndTime) { (str) in
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

