//
//  BottomView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/26.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BottomView: UIView {

    /// 展示底部弹窗
    ///
    /// - Parameter baseView: 父视图
    class func showBottomView(baseView: UIView? = nil) {
        
        let fatherView = (baseView ?? kWindow)
        if let _ = BottomView.currentTool { return }
        
        let tool = BottomView.loadXibView()
        tool.alpha = 0.0
        fatherView.addSubview(tool)
        BottomView.currentTool = tool

        tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)

        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.showView.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
        }
    }
    
    /// 隐藏底部弹窗
    class func hiddenBottomView() {
        
        guard let tool = BottomView.currentTool else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            tool.alpha = 0.0
            tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)
            
        }) { (isOK) in
            
            tool.removeFromSuperview()
            BottomView.currentTool = nil
        }
    }
    
    /// 展示控件的父视图
    @IBOutlet private weak var showView: UIView!
    /// 当前活跃的对象
    private static var currentTool: BottomView?
    
    /// 从xib加载
    private class func loadXibView() -> BottomView {
        let tool = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?.first as! BottomView
        tool.frame = UIScreen.main.bounds

        return tool
    }
    
    //MARK: Overwrite
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showView.corner(byRoundingCorners: [UIRectCorner.topLeft,  UIRectCorner.topRight], radii: 8.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        BottomView.hiddenBottomView()
    }
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}


extension UIView {
    
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: CGRect.init(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: self.bounds.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
