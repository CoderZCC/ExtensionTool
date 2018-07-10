//
//  ViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height
let kNavBarHeight: CGFloat = kHeight > 736.0 ? (88.0) : (64.0)
let kWindow = UIApplication.shared.keyWindow
let kRootVC = kWindow?.rootViewController
let kBottomSpace: CGFloat = kHeight > 736.0 ? (34.0) : (0.0)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)

        self.view.addSubview(self.textField)
        self.textField.k_placeholderColor = UIColor.red
    }

    lazy var textField: UITextField = {
        let tf = UITextField.init(frame: CGRect.init(x: 40.0, y: 100.0, width: kWidth - 40.0, height: 35.0))
        tf.placeholder = "asdkaj"
        return tf
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

