//
//  MyTabBarController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/10/15.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    /// 所有的按钮
    private var allBtns: [UIButton] = []
    /// 按钮宽度
    private var tabBarW: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 移除系统自带的按钮
        for subView in self.tabBar.subviews {
            
            if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                subView.removeFromSuperview()
            }
        }
    }
    
    override var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.createTabBarItems()
        }
    }
   
    /// 创建自定义按钮组
    private func createTabBarItems() {
        
        guard let viewControllers = self.viewControllers else { return }
        let tabbarW: CGFloat = kWidth / CGFloat(viewControllers.count)
        let tabbarH: CGFloat = 49.0
        self.tabBarW = tabbarW
        
        for (i, chiledVC) in viewControllers.enumerated() {
            
            let btn = UIButton.init(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: tabbarW * CGFloat(i), y: 0.0, width: tabbarW, height: tabbarH)
            btn.setTitle(chiledVC.title, for: .normal)
            btn.setImage(chiledVC.tabBarItem.image, for: .normal)
            btn.setImage(chiledVC.tabBarItem.selectedImage, for: .disabled)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(UIColor.white, for: .disabled)
            
            btn.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 0.0)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btn.tag = i
            btn.isEnabled = !(i == self.selectedIndex)
            
            self.allBtns.append(btn)
            self.moveIdentiferViewTo(self.selectedIndex)
            
            btn.k_addTarget { [unowned self] in
                
                for btn in self.allBtns {
                    btn.isEnabled = true
                }
                self.selectedIndex = btn.tag
                btn.isEnabled = false
                
                self.moveIdentiferViewTo(btn.tag)
            }
            self.tabBar.insertSubview(btn, belowSubview: self.identifierView)
        }
    }

    /// 标记符移动
    private func moveIdentiferViewTo(_ index: Int) {
        
        for btn in self.allBtns {
            btn.backgroundColor = UIColor.white
        }
        let btn = self.allBtns[index]
        UIView.animate(withDuration: 0.25, animations: {
            
            btn.backgroundColor = UIColor.darkGray
            self.identifierView.transform = CGAffineTransform.init(translationX: self.tabBarW * CGFloat(index), y: 0.0)
        })
    }
    /// 标记符
    private lazy var identifierView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tabBarW, height: 2.0))
        view.backgroundColor = UIColor.red
        
        self.tabBar.addSubview(view)
        
        return view
    }()
    
}
