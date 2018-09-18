//
//  SecondViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class SecondViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.textView)
        self.view.addSubview(self.tool)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var textView: UITextView = {
        let tv = UITextView.init(frame: CGRect(x: 15.0, y: 20.0, width: kWidth - 30.0, height: 200.0))
        tv.backgroundColor = UIColor.lightGray
        
        return tv
    }()
    
    lazy var tool: BottomInputView5 = {
        let tool = BottomInputView5.initWith(self.textView, block: { (img) in
            
            
        })
        return tool
    }()

}
