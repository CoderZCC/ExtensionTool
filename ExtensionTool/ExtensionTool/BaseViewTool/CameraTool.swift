//
//  CameraTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CameraTool: NSObject {

    static var instanced: CameraTool?
    /// 拍照的回调
    private var callBack: ((UIImage) -> Void)?
}

//MARK: 开始拍照
extension CameraTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 从相册获取照片
    ///
    /// - Parameter callBack: 图片回调
    class func takeImage(callBack: ((UIImage) -> Void)?) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            print("设备不支持图库")
            return
        }
        let tool = CameraTool()
        tool.callBack = callBack
        CameraTool.instanced = tool
        
        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = tool
        
        kRootVC.present(imgPicker, animated: true, completion: nil)
    }
    
    /// 开始拍照
    ///
    /// - Parameter callBack: 图片回调
    class func takePhoto(callBack: ((UIImage) -> Void)?) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            print("设备不支持摄像头")
            return
        }
        let tool = CameraTool()
        tool.callBack = callBack
        CameraTool.instanced = tool
        
        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .camera
        imgPicker.delegate = tool
        
        kRootVC.present(imgPicker, animated: true, completion: nil)
    }
    
    /// 完成
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            picker.dismiss(animated: true) {
                
                CameraTool.instanced?.callBack?(img)
                CameraTool.instanced = nil
            }
        }
    }
}
