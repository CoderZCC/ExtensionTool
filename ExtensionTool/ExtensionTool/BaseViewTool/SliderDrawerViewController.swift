//
//  SliderDrawerViewController.swift
//  侧滑控制器Demo
//
//  Created by 张崇超 on 2017/12/22.
//  Copyright © 2017年 zcc. All rights reserved.
//

import UIKit

protocol SliderDrawerDelegate: NSObjectProtocol {
    
    /// 侧边栏显示
    func leftViewAppear()
    /// 侧边栏隐藏 optional
    func leftViewDisAppear()
}

class SliderDrawerViewController: UIViewController {

    /// 是否需要收起
    var isNeedHidden: Bool = false
    /// 代理
    var sliderDelegate: SliderDrawerDelegate?
    /// 主控制器
    var mainVC: UIViewController!
    /// 侧边栏
    var leftVC: UIViewController!
    private var maxWidth: CGFloat!
    
    /// 创建侧滑控制器
    convenience init( mainVC: UIViewController, leftVC: UIViewController, leftWidth: CGFloat) {
        
        self.init(nibName: nil, bundle: nil)
        self.mainVC = mainVC
        self.leftVC = leftVC
        self.maxWidth = leftWidth
        
        view.addSubview(leftVC.view)
        view.addSubview(mainVC.view)
        addChild(leftVC)
        addChild(mainVC)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftVC.view.transform = CGAffineTransform.init(translationX: -self.maxWidth, y: 0.0)

        for childVC in self.mainVC.children {

            self.addScreenEdgePanGestureRecognizerToView(view: childVC.view)
        }
    }
    
    //MARK: -添加平移手势
    private func addScreenEdgePanGestureRecognizerToView(view: UIView) {
        
        let pan: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGestureAction))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
    }
    
    //MARK: -灰色背景按钮
    private lazy var rightMaskBtn: UIButton = { [unowned self] in
        
        let btn = UIButton(frame: self.mainVC.view.bounds)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(hiddenLeftVC), for: .touchUpInside)
        btn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCloseLeftMenu)))
        
        return btn
    }()
}

//MARK: -点击事件Action
extension SliderDrawerViewController {
    
    //MARK: -平移手势事件
    @objc func edgePanGestureAction(_ pan:UIScreenEdgePanGestureRecognizer) {
        
        let offSetX: CGFloat = pan.translation(in: pan.view).x
        
        if pan.state == .changed && offSetX <= self.maxWidth {
            
            self.mainVC.view.transform = CGAffineTransform.init(translationX: max(offSetX, 0), y: 0)
            self.leftVC.view.transform = CGAffineTransform.init(translationX: -self.maxWidth + offSetX, y: 0)
           
            if offSetX == self.maxWidth {
                
                self.sliderDelegate?.leftViewAppear()
                
            } else if offSetX == 0 {
                
                self.sliderDelegate?.leftViewDisAppear()
            }
            
        } else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed {
            
            offSetX > self.maxWidth * 0.3 ? (self.showLeftVC()):(self.hiddenLeftVC())
        }
    }
    
    //MARK: -展示侧边栏
    func showLeftVC() {
        
        self.isNeedHidden = true
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            
            self.leftVC.view.transform = CGAffineTransform.identity
            self.mainVC.view.transform = CGAffineTransform(translationX: self.maxWidth, y: 0)
            
        }) { [unowned self] (isOK) in
            
            self.mainVC.view.addSubview(self.rightMaskBtn)
            self.sliderDelegate?.leftViewAppear()
        }
    }
    
    //MARK: -隐藏侧边栏
    @objc func hiddenLeftVC() {
        
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            
            self.leftVC.view.transform = CGAffineTransform.init(translationX: -self.maxWidth, y: 0.0)
            self.mainVC.view.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
            self.rightMaskBtn.removeFromSuperview()
            self.sliderDelegate?.leftViewDisAppear()
            self.isNeedHidden = false
        }
    }
    
    //MARK: - 遮盖按钮手势
    @objc func panCloseLeftMenu(_ pan: UIPanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        if offsetX > 0 {return}
        
        if pan.state == UIGestureRecognizer.State.changed && offsetX >= -maxWidth {
            
            let distace = self.maxWidth + offsetX
            
            self.mainVC.view.transform = CGAffineTransform(translationX: distace, y: 0)
            self.leftVC.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            
            if offsetX == -self.maxWidth {
                
                self.sliderDelegate?.leftViewDisAppear()
                
            } else if offsetX == 0 {
                
                self.sliderDelegate?.leftViewAppear()
            }
            
        } else if pan.state == .ended || pan.state == .cancelled || pan.state == .failed {
            
            offsetX > -kWidth * 0.5 ? (self.showLeftVC()):(self.hiddenLeftVC())
        }
    }
}
