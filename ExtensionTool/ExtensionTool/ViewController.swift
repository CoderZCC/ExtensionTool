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
        
        self.view.backgroundColor = UIColor.k_colorWith(r: 216.0, g: 216.0, b: 216.0)
        
        self.view.addSubview(self.imgV)
        
        self.imgV.addTarget(self, action: #selector(imgAction))
    }

    @objc func imgAction() {
        
        
    }
    
    lazy var imgV: CircleImageView = {
        let imgV = CircleImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        imgV.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y - 120.0)
        imgV.image = UIImage.init(named: "1")
//        imgV.image = UIImage.init(named: "1")?.k_circleImage(backColor: self.view.backgroundColor!)

        return imgV
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

