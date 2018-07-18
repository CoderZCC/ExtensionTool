//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func k_setImage(url: String) -> UIImage {
        
        // 缓存
        if let imgData = kCachesImgDic[url] {
            
            return UIImage.init(data: imgData) ?? #imageLiteral(resourceName: "defaultImg")
        }
        // 磁盘
        let dic = kSaveDataTool.k_getData(from: kCachesImgDicPath)
        if let imgData = dic[url] as? Data {
            
            kCachesImgDic[url] = imgData
            return UIImage.init(data: imgData) ?? #imageLiteral(resourceName: "defaultImg")
        }      
        return #imageLiteral(resourceName: "defaultImg")
    }
    
    //MARK: 裁剪方形图片为圆形
    /// 裁剪方形图片为圆形
    ///
    /// - Parameter backColor: 填充颜色,默认白色
    /// - Returns: 新图片
    func k_circleImage(backColor: UIColor = UIColor.white) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(), size: self.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 形状
        let circlePath = UIBezierPath.init(ovalIn: rect)
        circlePath.addClip()
        
        self.draw(in: rect)
        
        UIColor.darkGray.setStroke()
        circlePath.lineWidth = 1.0
        circlePath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
    
    //MARK: 压缩图片大小
    /// 压缩图片大小
    ///
    /// - Parameter maxSizeKB: 最大尺寸 80.0KB
    /// - Returns: 数据流
    func k_pressImgSize(maxSizeKB: CGFloat = 80.0) -> Data {
        
        var maxSize = maxSizeKB
        let maxImageSize: CGFloat = 1024.0
        
        if (maxSize <= 0.0) {
            
            maxSize = 1024.0;
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: self.size.width, height: self.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
            
        } else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        //调整大小
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
        }
        return imageData!
    }
    
}
