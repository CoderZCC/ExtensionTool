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
        
        /*
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        */
        
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)
        self.k_setupMyNavBar()
        
        self.k_navigationItem(title: "切换") {
            
            LanguageTool.setUserLanguage(LanguageTool.currentLanguage == .ch ? LanguageType.en : LanguageType.ch)
        }
        
        self.k_addObserver(name: .userLanguageChanged) { [weak self] (note) in
            
            self?.title_locailedStr = self?.k_title
            
            self?.k_navigationItem(title: "切换") {
                
                LanguageTool.setUserLanguage(LanguageTool.currentLanguage == .ch ? LanguageType.en : LanguageType.ch)
            }
        }
        
    } 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        
        self.k_removeObserver(name: .userLanguageChanged)
        debugPrint("###\(self)销毁了###\n")
    }
}

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title_locailedStr = "首页"
    }
    
    var str: String = ""
    
    @IBAction func btnAction() {

        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

