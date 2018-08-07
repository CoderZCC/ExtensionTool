//
//  CellDetailView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellDetailView: UIView {

    static func showDetail(currentImg: UIImage?, originalFrame: CGRect) {
        
        let tool = CellDetailView.init(frame: UIScreen.main.bounds)
        tool.originalFrame = originalFrame
        
        // 添加动画View
        tool.falseImgV.frame = originalFrame
        tool.falseImgV.alpha = 1.0
        tool.falseImgV.image = currentImg
        kWindow.addSubview(tool.falseImgV)
        
        // 添加最终展示的View
        tool.alpha = 0.0
        kWindow.addSubview(tool)
        
        // 执行放大动画
        UIView.animate(withDuration: 0.2, animations: {
            
            tool.falseImgV.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
            
        }) { (isOk) in
            
            // 隐藏动画View
            //tool.falseImgV.alpha = 0.0
            // 展示出最终View
            //tool.alpha = 1.0
        }
    }
    
    private var originalFrame: CGRect?
    
    //MARK: -懒加载
    /// 假的View,用于处理放大动画
    lazy var falseImgV: UIImageView = {
        let imgV: UIImageView = UIImageView.init()
        imgV.contentMode = .scaleAspectFit
        imgV.backgroundColor = UIColor.black
        imgV.k_addTarget({ (tap) in
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.falseImgV.frame = self.originalFrame ?? CGRect.zero
                
            }, completion: { (isOK) in
                
                self.falseImgV.alpha = 0.0
                self.falseImgV.removeFromSuperview()
            })
        })
        
        return imgV
    }()

}
