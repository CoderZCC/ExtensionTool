//
//  CameraTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

class CameraTool: NSObject, PHPhotoLibraryChangeObserver {

    /// 导航栏
    var pickerNavVC: UINavigationController!
    /// 是否裁剪图片
    var isClipImg: Bool = false
    /// 需要他保证创建的对象不会被销毁
    fileprivate static var instanced: CameraTool? {
        willSet {
            // 请求权限
            if !AuthorityTool.canSaveMediaToAlbum() {
                print("无权限")
            }
        }
    }
    /// 拍照的回调
    fileprivate var callBack: ((UIImage) -> Void)?
    /// 是否拍照获取
    fileprivate var isFromCamera: Bool = false
    /// 从相册获取照片
    ///
    /// - Parameter callBack: 图片回调
    @discardableResult
    class func takeImgFromLibrary(callBack: ((UIImage) -> Void)?) -> CameraTool? {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            print("设备不支持图库")
            return nil
        }
        let tool = CameraTool()
        tool.callBack = callBack
        tool.isFromCamera = false
        CameraTool.instanced = tool

        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = CameraTool.instanced
        
        kRootVC.present(imgPicker, animated: true, completion: nil)
        
        return CameraTool.instanced
    }
    
    /// 开始拍照
    ///
    /// - Parameter callBack: 图片回调
    class func takeImgFromCamera(callBack: ((UIImage) -> Void)?) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            print("设备不支持摄像头")
            return
        }
        let tool = CameraTool()
        tool.callBack = callBack
        tool.isFromCamera = true
        CameraTool.instanced = tool

        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .camera
        imgPicker.delegate = CameraTool.instanced
        
        kRootVC.present(imgPicker, animated: true, completion: nil)
    }
    
    /// 获取所有图片
    ///
    /// - Returns: [PHAsset]
    lazy var imgsArr: [PHAsset] = {
       
        var arr: [PHAsset] = []
        PHPhotoLibrary.shared().register(self)
        let allOptions = PHFetchOptions.init()
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        
        let allResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: allOptions)
        for index in 0..<allResult.count {
            
            let asset: PHAsset = allResult[index]
            if asset.mediaType == .image {
                
                arr.append(asset)
            }
        }
        return arr
    }()
    
    // 第一次获取权限时使用
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        
    }

    deinit {
        
        print("##\(self)销毁了## \n")
    }
}

//MARK: 开始拍照
extension CameraTool: UIImagePickerControllerDelegate {
    
    /// 完成
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            DispatchQueue.main.async {
                
                let newVC = PreviewViewController.init(img: img, isClip: self.isClipImg, block: { (img) in
                    
                    CameraTool.instanced = nil
                    self.callBack?(img)
                    picker.dismiss(animated: true, completion: nil)
                })
                
                if self.isFromCamera {
                    
                    picker.dismiss(animated: true, completion: nil)
                    kRootVC.present(newVC, animated: true, completion: nil)
                    
                } else {
                    
                    self.pickerNavVC.pushViewController(newVC, animated: true)
                }
            }
        }
    }
}

extension CameraTool: UINavigationControllerDelegate {
    
    // 设置导航栏
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.pickerNavVC = navigationController
        if navigationController.viewControllers.count > 1 { return }
        let navBar = navigationController.navigationBar
        // 标题
        navBar.topItem?.title = "选择照片"
        // 导航栏颜色
        navBar.barTintColor = UIColor.red
        // 设置导航栏上按钮的颜色
        navBar.tintColor = UIColor.white
        // 设置标题文字颜色
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // 设置返回按钮上的文字
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
    }
}
