//
//  MyPageControl.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/27.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class MyPageControl: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setValue(UIImage.init(named: "test"), forKeyPath: "_pageImage")
        self.setValue(UIImage.init(named: "test"), forKeyPath: "_currentPageImage")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
