//
//  FalseNavBarView.swift
//  导航栏的控制
//
//  Created by 张崇超 on 2018/6/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 初始化导航栏
    func initNavBar(color: UIColor, alpha: CGFloat, leftBtnStyle: Any? = nil) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let tool = FalseNavBarView.initNavBar(color: color, alpha: alpha, leftBtnStyle: leftBtnStyle ?? UIButton(), title: self.title)
        
        // 添加右滑返回手势
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(kScrolToBackAction))
        self.view.addGestureRecognizer(pan)
        
        self.view.addSubview(tool)
        
        // 在右侧添加
        if let _ = FalseNavBarView.lastPageScrrenSnapshot {
            
            let imgV = tool.falseScrrenView
            self.view.addSubview(imgV)
            
        } else {
            
            assert(1 < 0, "查看属性'FalseNavBarView/lastPageScrrenSnapshot'")
        }
    }
    
    @objc func kScrolToBackAction(pan: UIPanGestureRecognizer) {

        let offsetX = pan.translation(in: self.view).x
        if offsetX < 0.0 { return }
        let falseTool = FalseNavBarView.initSelf
        var alpha = offsetX / kWidth
        alpha = min(1.0, max(0.0, alpha))
        
        if pan.state == .changed {
        
            // 开始位移
            self.view.transform = CGAffineTransform(translationX: offsetX, y: 0.0)
            
        } else if pan.state == .ended || pan.state == .cancelled {
            
            if alpha >= 0.3 {
            
                // 返回
                self.scrollBack()
                
            } else {
                
                // 恢复原样
                UIView.animate(withDuration: 0.3) {
                    
                    self.view.transform = CGAffineTransform.identity
                    self.changeNavBarAlpha(alpha: falseTool?.currentAlpha)
                }
            }
            
        }
    }
    
    /// 改变导航栏透明度
    func changeNavBarAlpha(alpha: CGFloat?) {
        
        let tool = FalseNavBarView.initSelf
        tool?.backgroundColor = tool?.backgroundColor?.withAlphaComponent(alpha ?? 0.0)
        tool?.currentAlpha = alpha ?? 0.0
    }
    
    /// 重设导航栏
    func resetNavBar() {
      
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // 防止滚动时返回 导航栏空白
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            FalseNavBarView.initSelf?.removeFromSuperview()
            FalseNavBarView.initSelf = nil
        }
    }
    
    /// 侧滑返回使用
    private func scrollBack() {
        
        // 移除左侧假的试图
        FalseNavBarView.initSelf?.falseScrrenView.isHidden = true
        FalseNavBarView.initSelf?.falseScrrenView.removeFromSuperview()
        // 返回上一级
        self.navigationController?.popViewController(animated: true)
        // 展示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // 移除假导航栏
        FalseNavBarView.initSelf?.removeFromSuperview()
        FalseNavBarView.initSelf = nil
    }
}

class FalseNavBarView: UIView {

    /// 当前展示的假导航栏
    static var initSelf: FalseNavBarView?
    /// 当前的透明度
    var currentAlpha: CGFloat = 0.0
    /// 上一个页面的截图 需要赋值 放在点击事件里即可
    /* FalseNavBarView.lastPageScrrenSnapshot = AppTool.getScreenSnapShot() */
    static var lastPageScrrenSnapshot: UIImage?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - color: 导航栏颜色
    ///   - alpha: 透明度
    ///   - leftBtnStyle: 左侧按钮 可以使 文字/图片名称/图片
    ///   - title: 标题
    class func initNavBar(color: UIColor, alpha: CGFloat, leftBtnStyle: Any, title: String?) -> FalseNavBarView {
        let tool = FalseNavBarView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kNavBarHeight))
        tool.backgroundColor = color.withAlphaComponent(alpha)
        
        if leftBtnStyle is String {
            
            let str = leftBtnStyle as! String
            if UIImage.init(named: str) != nil {
                
                tool.leftBtn.setImage(UIImage.init(named: str), for: .normal)
                tool.leftBtn.setImage(UIImage.init(named: str), for: .highlighted)

            } else {
                
                tool.leftBtn.setTitle(str, for: .normal)
            }
            
        } else if leftBtnStyle is UIImage {
            
            tool.leftBtn.setImage(leftBtnStyle as? UIImage, for: .normal)
            tool.leftBtn.setImage(leftBtnStyle as? UIImage, for: .highlighted)
        }
        tool.leftBtn.frame = CGRect.init(x: 0.0, y: kNavBarHeight - 38.0, width: 48.0, height: 30.0)
        tool.addSubview(tool.leftBtn)
        
        if let title = title {
            
            tool.titleL.text = title
            tool.titleL.frame = CGRect.init(x: (kWidth - 100.0) / 2.0, y: tool.leftBtn.frame.origin.y, width: 100.0, height: 30.0)
            tool.addSubview(tool.titleL)
        }
        FalseNavBarView.initSelf = tool
        return tool
    }

    /// 返回按钮点击事件
    @objc func backAction() {
        
        AppTool.getCurrentNavVC()?.popViewController(animated: true)
    }
    
    /// 返回按钮
    lazy var leftBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return btn
    }()
    /// 标题
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()
    /// 上一级的View,用于做动画
    lazy var falseScrrenView: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect.init(x: -kWidth, y: 0.0, width: kWidth, height: kHeight))
        imgV.image = FalseNavBarView.lastPageScrrenSnapshot
        
        return imgV
    }()
}

class AppTool: NSObject {
    
    /// 截取屏幕
    @discardableResult
    static func getScreenSnapShot() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(kWindow.bounds.size, false, 0.0)
        kWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    /// 获取当前活跃的导航栏控制器
    static func getCurrentNavVC() -> UINavigationController? {
        
        if kRootVC is UINavigationController {
            
            let navVC = kRootVC as! UINavigationController
            return navVC
            
        } else if kRootVC is UITabBarController {
            
            let tabVC = kRootVC as! UITabBarController
            return tabVC.selectedViewController as? UINavigationController
        }
        return nil
    }
    /// 获取当前展示的控制器
    static func getCurrentVC() -> UIViewController? {
        return AppTool.getCurrentVCMethod(superVC: kRootVC)
    }
    private static func getCurrentVCMethod(superVC: UIViewController? = nil) -> UIViewController? {
        
        if let superVC = superVC {
            
            var rootVC: UIViewController = superVC
            var currentVC: UIViewController?
            
            // 是否有弹出控制器
            if let presentVC = rootVC.presentedViewController {
                
                rootVC = presentVC
            }
            
            if rootVC is UINavigationController {
                
                let navVC = rootVC as! UINavigationController
                currentVC = self.getCurrentVCMethod(superVC: navVC.visibleViewController)
                
            } else if rootVC is UITabBarController {
                
                let tabVC = rootVC as! UITabBarController
                currentVC = self.getCurrentVCMethod(superVC: tabVC.selectedViewController)
                
            } else {
                
                currentVC = rootVC
            }
            return currentVC
        }
        return nil
    }
}
