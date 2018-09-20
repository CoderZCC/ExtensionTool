//
//  SecondViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        //self.view.addSubview(self.webView)
        
//        LoadingTool.sharedInstance.showText1("您的验证码已发送,请注意查收")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//
//            self.navigationController?.popViewController(animated: true)
//            LoadingTool.sharedInstance.showText1("哈哈哈")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //        let secondVC = SecondViewController()
        //        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.view.k_width, height: self.view.k_height))
        webView.load(URLRequest.init(url: URL.init(string: "https://www.apple.com/cn/")!))
//        webView.k_progressColor = UIColor.orange
        webView.k_progressColor = nil

        return webView
    }()

}
