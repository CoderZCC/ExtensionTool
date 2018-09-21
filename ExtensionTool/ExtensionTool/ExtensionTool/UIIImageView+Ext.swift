//
//  UIIImageView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var kCachesImgDic: [String: Data] = [:]
let kCachesImgDicPath: String = String.k_documentsPath + "cachesImg.plist"

extension UIImageView {
    
    /// 设置内容模式
    ///
    /// - Parameters:
    ///   - model: 模式
    ///   - clips: 是否裁剪
    func k_contenModel(model: UIView.ContentMode = .scaleAspectFill, clips: Bool = true) {
        
        self.contentMode = model
        self.clipsToBounds = clips
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - url: 图片地址
    ///   - placeholder: 占位图片
    func k_setImage(url: String, placeholder: UIImage = #imageLiteral(resourceName: "photo")) {
        
        if let imgData = kCachesImgDic[url] {
            
            self.image = UIImage.init(data: imgData)
            return
        }
        let dic = kSaveDataTool.k_getData(from: kCachesImgDicPath)
        if let imgData = dic[url] as? Data {
            
            kCachesImgDic[url] = imgData
            self.image = UIImage.init(data: imgData)
            return
        }
        self.image = placeholder
        if let imgUrl = URL.init(string: url.replacingOccurrences(of: " ", with: "%20")) {
            
            DispatchQueue.global().async {
                
                do {
                    let imgData =
                        try Data.init(contentsOf: imgUrl)
                    DispatchQueue.main.async {
                        
                        self.image = UIImage.init(data: imgData)
                    }
                    kCachesImgDic[url] = imgData
                    kSaveDataTool.k_saveData(dic: kCachesImgDic as [String: Any], to: kCachesImgDicPath)
                    
                } catch {
                    
                    print("图片加载失败")
                }
            }
        }
    }
    
}
