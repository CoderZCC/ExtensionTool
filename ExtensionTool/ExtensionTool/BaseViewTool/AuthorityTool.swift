//
//  MediaTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import AssetsLibrary

enum kLocationType {
    case whenInUse, always
}

class AuthorityTool: NSObject {
    
    class func gotoSetting() {
     
        kWindow.showAlertView(title: "请在iPhone的\"设置\"中允许访问此项权限", message: nil) {
            
            let url = URL.init(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(url!)
        }
    }
}

//MARK: 是否可用摄像头
extension AuthorityTool {
    
    //MARK: 是否可用摄像头
    /// 是否可用摄像头
    ///
    /// - Returns: true/false
    @discardableResult
    class func canUseCamera(block:(()->Void)? = nil) -> Bool {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            print("设备不支持摄像头")
            return false
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .notDetermined {
            
            AVCaptureDevice.requestAccess(for: .video) { (isOK) in
                
                if isOK { block?() }
                self.canUseCamera()
            }
            return true
            
        } else if status == .restricted || status == .denied {
            
            self.gotoSetting()
            return false
            
        } else {
            
            return true
        }
    }
}

//MARK: 获取定位权限
extension AuthorityTool {
    
    //MARK: 是否可以访问定位服务
    private static let locationMgr: CLLocationManager = CLLocationManager.init()
    /// 是否可以访问定位服务
    ///
    /// - Parameter type: 请求类型
    /// - Returns: true/false
    @discardableResult
    class func canUseLocation(type: kLocationType = .whenInUse) -> Bool {
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            
            if type == .whenInUse {
                AuthorityTool.locationMgr.requestWhenInUseAuthorization()
            } else {
                AuthorityTool.locationMgr.requestAlwaysAuthorization()
            }
            return true
            
        } else if status == .restricted || status == .denied {
            
            self.gotoSetting()
            return false
            
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            return true
        }
        return true
    }
}

//MARK: 保存媒体资源到相册
extension AuthorityTool {
    
    //MARK: -保存媒体文件到图库
    /// 保存媒体文件到图库
    ///
    /// - Parameters:
    ///   - img: 图片
    ///   - videoPath: 视频地址
    ///   - result: true/false
    class func saveMediaToAlbum(img: UIImage?, videoPath: String? = nil, result: ((Bool)->Void)?) {
        
        if !self.canUseAlbum() { return }
        PHPhotoLibrary.shared().performChanges({
            
            if let img = img {
                
                PHAssetChangeRequest.creationRequestForAsset(from: img)
                
            } else if let path = videoPath {
                
                let url: URL = URL.init(fileURLWithPath: path)
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }
            
        }) { (isOK, error) in
            
            result?(isOK)
            if let error: NSError = error as NSError?, error.code == 2047 {
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    
                    DispatchQueue.main.async {
                        AuthorityTool.saveMediaToAlbum(img: img, videoPath: videoPath, result: result)
                    }
                }
            }
        }
    }
    
    //MARK: -是否可以保存媒体资料到图库
    /// 是否可以保存媒体资料到图库
    ///
    /// - Returns: true/false
    @discardableResult
    class func canUseAlbum(block:(()->Void)? = nil) -> Bool {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                DispatchQueue.main.async {
                    AuthorityTool.canUseAlbum()
                    if status == .authorized { block?() }
                }
            }
            return true
            
        } else if status == .restricted || status == .denied {
            
            self.gotoSetting()
            return false
            
        } else {
            
            return true
        }
    }
}

