//
//  CameraTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

enum CameraType {
    case library, camera
}

class CameraTool: NSObject {

    /// 数据源
    var dataList: [AlbumModel] = []
    /// 拍照的回调
    fileprivate var callBack: ((UIImage) -> Void)?
    /// 是否裁剪图片
    fileprivate var isClipImg: Bool = false
    
    /// 获取一张图片
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - isCrop: 是否裁剪
    ///   - block: 回调
    class func takeFrom(type: CameraType = .library, isCrop: Bool = false, block: ((UIImage)->Void)?) {
        
        if type == .library {
            
            self.takeFromLibrary(isCrop: isCrop, block: block)
            
        } else {
            
            self.takeFromCamera(isCrop: isCrop, block: block)
        }
    }
    
    /// 从图库获取图片
    ///
    /// - Parameters:
    ///   - isCrop: 是否裁剪
    ///   - block: 图片回调
    class func takeFromLibrary(isCrop: Bool = false, block: ((UIImage)->Void)?) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            print("设备不支持图库")
            return
        }
        let cameraVC = CameraViewController()
        let nav = UINavigationController.init(rootViewController: cameraVC)
        cameraVC.block = block
        cameraVC.isCrop = isCrop
        
        kRootVC.present(nav, animated: true, completion: nil)
    }
    
    /// 从相机获取图片
    ///
    /// - Parameters:
    ///   - isCrop: 是否裁剪
    ///   - block: 图片回调
    class func takeFromCamera(isCrop: Bool = false, block: ((UIImage)->Void)?) {
        
        if !AuthorityTool.requestCameraAuthor() {
            
            print("设备不支持摄像头")
            return
        }
        let tool = CameraTool()
        tool.callBack = block
        tool.isClipImg = isCrop
        
        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .camera
        imgPicker.delegate = tool
        
        kRootVC.present(imgPicker, animated: true, completion: nil)
    }
    
    deinit {
        print("\n====== \(self) 销毁了======\n")
    }
}

class AlbumModel: NSObject {
    
    var title: String = ""
    var fetchResult: PHFetchResult<PHAsset>?
    /// 数据源
    lazy var dataList: [PHAsset] = {
        var arr: [PHAsset] = []
        if self.fetchResult == nil {return arr}
        for index in 0..<self.fetchResult!.count {
            
            arr.append(self.fetchResult![index])
        }
        return arr.reversed()
    }()
    
    convenience init(title: String, fetchResult: PHFetchResult<PHAsset>) {
        self.init()
        
        self.title = title
        self.fetchResult = fetchResult
    }
}

extension CameraTool {
    
    /// 获取所有的相册
    func getAllAlbums() {
        
        self.dataList.removeAll()
        let options = PHFetchOptions()
        // 系统相簿
        let systemAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
        self.convertCollection(col: systemAlbum)
        
        // 用户相簿
        let userAlbum = PHCollectionList.fetchTopLevelUserCollections(with: options)
        self.convertCollection(col: userAlbum as! PHFetchResult<PHAssetCollection>)
    }
    
    func convertCollection(col: PHFetchResult<PHAssetCollection>) {
        
        for index in 0..<col.count {
            
            let obj = col[index]
            let resultOption = PHFetchOptions()
            resultOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
            resultOption.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            let result = PHAsset.fetchAssets(in: obj, options: resultOption)
            if result.count > 0 {
                
                let title = obj.localizedTitle ?? ""
                if title != "最近删除" && title != "Recently Deleted" {
                    
                    let model = AlbumModel.init(title: title, fetchResult: result)
                    self.dataList.append(model)
                }
            }
        }
    }
}

//MARK: 开始拍照
extension CameraTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 完成
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            DispatchQueue.main.async { [unowned self] in
                
                let previewVC = CameraPreviewViewController()
                previewVC.thumbImg = img
                previewVC.isCrop = self.isClipImg
                previewVC.block = self.callBack
                
                picker.dismiss(animated: true, completion: nil)
                kRootVC.present(previewVC, animated: true, completion: nil)
            }
        }
    }
}

/*
extension CameraTool: UINavigationControllerDelegate {
    
    // 设置导航栏 没用处
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
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
*/
