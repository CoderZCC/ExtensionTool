//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import CoreFoundation

enum PlaceholderImg: String {
    
    var k_toImage: UIImage? {
        return UIImage.init(named: self.k_toString)
    }
    
    /// 转为字符串
    var k_toString: String {
        
        return self.rawValue
    }
    /// 无数据
    case noData
    /// 无网络
    case noNetwork
    /// 未关注
}

extension UIImage {
    
    /// 根据颜色创建一个图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    static func k_imageWithColor(_ color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let ref = UIGraphicsGetCurrentContext()
        ref?.setFillColor(color.cgColor)
        ref?.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
    static func k_init(type: PlaceholderImg) -> UIImage? {
        
        return type.k_toImage
    }
    
    //MARK: 获取View的截图
    /// 获取View的截图
    ///
    /// - Parameter view: view 默认是屏幕
    /// - Returns: 截图
    class func k_screenSnap(view: UIView = kWindow) -> UIImage {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        let ctx = UIGraphicsGetCurrentContext()
        view.layer.render(in: ctx!)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg!
    }
    
    //MARK: 改变图片尺寸
    /// 改变图片尺寸
    ///
    /// - Parameter size: 修改的尺寸
    /// - Returns: 新图片
    func k_cropImageWith(newSize: CGSize) -> UIImage {
        
        let scale = self.size.width / self.size.height
        var rect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        if scale > newSize.width / newSize.height {
            
            rect.size.width = self.size.height * newSize.width / newSize.height
            rect.origin.x = (self.size.width - rect.size.width) / 2.0
            rect.size.height = self.size.height

        } else {
            
            rect.origin.y = (self.size.height - self.size.width / newSize.width * newSize.height) / 2.0
            rect.size.width = self.size.width
            rect.size.height = self.size.width / newSize.width * newSize.height
        }
        let imgRef = self.cgImage!.cropping(to: rect)
        let newImg = UIImage.init(cgImage: imgRef!)
        
        return newImg
    }
    
    //MARK: 裁剪圆形为圆形
    /// 裁剪为圆形图片
    ///
    /// - Parameters:
    ///   - backColor: 裁剪为圆形 空白区域的背景颜色 默认白色
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    /// - Returns: 新图片
    func k_circleImage(backColor: UIColor? = UIColor.white, borderColor: UIColor? = nil, borderWidth: CGFloat? = 0.0) -> UIImage {
        
        // 圆形图片
        let imgW: CGFloat = self.size.width
        let imgH: CGFloat = self.size.height
        let imgWH: CGFloat = min(imgW, imgH)
        let squareImg = self.k_cropImageWith(newSize: CGSize.init(width: imgWH, height: imgWH))
        // 圆形框
        let rect = CGRect(origin: CGPoint(), size: squareImg.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 填充
        (backColor ?? UIColor.white).setFill()
        UIRectFill(rect)
        
        // 形状
        let circlePath = UIBezierPath.init(ovalIn: rect)
        circlePath.addClip()
        
        squareImg.draw(in: rect)
        
        // 是否有边框
        if let borderColor = borderColor {
            
            borderColor.setStroke()
            circlePath.lineWidth = borderWidth ?? 1.0
            circlePath.stroke()
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
    
    //MARK: 压缩图片大小
    /// 压缩图片大小
    ///
    /// - Parameters:
    ///   - imgSize: 图片大小 默认原图尺寸
    ///   - kbSize: 压缩大小
    /// - Returns: 数据流
    func k_pressImgSize(imgSize: CGSize? = nil, kbSize: CGFloat = 80.0) -> Data {
        
        // kb大小
        var maxSize = kbSize
        let maxImageSize: CGFloat = 1024.0
        
        if (maxSize <= 0.0) {
            
            maxSize = 1024.0;
        }
        // 宽高
        var newImg = self
        if let imgSize = imgSize {
            
            newImg = self.k_cropImageWith(newSize: imgSize)
        }
        //先调整分辨率
        var newSize = CGSize.init(width: newImg.size.width, height: newImg.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: newImg.size.width / tempWidth, height: newImg.size.height / tempWidth)
            
        } else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: newImg.size.width / tempHeight, height: newImg.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        
        newImg.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageData = newImage!.jpegData(compressionQuality: 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        //调整大小
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = newImage!.jpegData(compressionQuality: CGFloat(resizeRate));
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
        }
        return imageData!
    }
    
}
