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
     
        self.view.addSubview(self.webView)
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
