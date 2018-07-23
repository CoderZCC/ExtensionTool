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
        self.view.backgroundColor = UIColor.k_colorWith(hexInt: 0x333333)
        
        self.view.addSubview(self.imgV)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        CameraTool.takeFromLibrary { (img) in
            
            self.imgV.image = img
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var imgV: UIImageView = {
        let imgV = UIImageView.init(frame: self.view.bounds)
        imgV.contentMode = .scaleAspectFit
        
        return imgV
    }()
}

class SecondViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
