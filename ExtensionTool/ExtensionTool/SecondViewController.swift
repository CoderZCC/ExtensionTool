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
     
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        HudTool.initSelf.showTextHUD("您的验证码已发送,请注意查收", isMask: true)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
//
//            HudTool.initSelf.showTextHUD("登录成功")
//
//        }

//        HudTool.initSelf.showTextHUD("登录成功")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//
//            HudTool.initSelf.showLoadingHUD()
//        }
        
        var value: CGFloat = 0.0
        
        self.k_startTimer(timeInterval: 0.1, repeats: true) { (timer) in
            
            value += 0.02
            HudTool.initSelf.showProgressHUD("下载中", progress: value) {
                
//                HudTool.initSelf.showTextHUD("登录成功")
                HudTool.initSelf.showLoadingHUD()
            }
            if value > 1.0 {
                
                timer?.cancel()
            }
           
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

