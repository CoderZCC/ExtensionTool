//
//  MediaTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class AuthorityTool: NSObject {
    
    class func gotoSetting() {
     
        kWindow.showAlert(title: "请在iPhone的\"设置\"中允许访问此项权限") {
            
            let url = URL.init(string: UIApplication.openSettingsURLString)
            UIApplication.shared.openURL(url!)
        }
    }
}

import Contacts
//MARK: 通讯录
extension AuthorityTool {
    
    /// 请求通讯录权限
    ///
    /// - Parameter block: 回调
    /// - Returns: true/false
    @discardableResult
    class func requestContactAuthor(block:(()->Void)? = nil) -> Bool {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .notDetermined {
            
            CNContactStore.init().requestAccess(for: .contacts) { (isOK, error) in
                
                if isOK {
                
                   block?()
                    
                } else {
                    
                    self.requestContactAuthor(block: block)
                }
            }
            return false

        } else if status == .restricted || status == .denied {
            
            return false

        } else {
            
            return true
        }
    }
    
    /// 获取通讯录列表
    class func getContactList() {
        
        let isOk = AuthorityTool.requestContactAuthor {
            
            self.getContactList()
        }
        if !isOk { return }
        
        let request = CNContactFetchRequest.init(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])
        
        do {
            try CNContactStore.init().enumerateContacts(with: request) { (contact, obj) in
                
                let givenName = contact.givenName
                let familyName = contact.familyName
                let name = familyName + givenName
                print(name)

                for value in contact.phoneNumbers {
                    
                    var phoneStr = value.value.stringValue
                    
                    phoneStr = phoneStr.replacingOccurrences(of: "-", with: "")
                    phoneStr = phoneStr.replacingOccurrences(of: "(", with: "")
                    phoneStr = phoneStr.replacingOccurrences(of: ")", with: "")
                    phoneStr = phoneStr.replacingOccurrences(of: " ", with: "")
                    phoneStr = phoneStr.replacingOccurrences(of: "+86", with: "")
                    
                    print(phoneStr)
                }
            }
            
        } catch {
            
            print("拉取失败")
        }
    }
}

import Photos
import AssetsLibrary

//MARK: 摄像头
extension AuthorityTool {
    
    //MARK: 请求摄像头权限
    /// 请求摄像头权限
    ///
    /// - Parameter block: 回调
    /// - Returns: true/false
    @discardableResult
    class func requestCameraAuthor(block: (()->Void)? = nil) -> Bool {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            print("设备不支持摄像头")
            return false
        }
        return AuthorityTool.requestAuthor(type: .video, block: block)
    }
    
    /// 请求麦克风权限
    ///
    /// - Parameter block: 回调
    /// - Returns: true/false
    @discardableResult
    class func requestAudioAuthor(block: (()->Void)? = nil) -> Bool {
        
        return AuthorityTool.requestAuthor(type: .audio, block: block)
    }
    
    /// 请求权限
    private class func requestAuthor(type: AVMediaType, block: (()->Void)? = nil) -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(for: type)
        if status == .notDetermined {
            
            AVCaptureDevice.requestAccess(for: type) { (isOK) in
                
                if isOK {
                    
                    block?()
                    
                } else {
                    
                    self.requestAlbumAuthor(block: block)
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

import CoreLocation

enum kLocationType {
    case whenInUse, always
}
//MARK: 定位
extension AuthorityTool {
    
    //MARK: 请求定位权限
    private static let locationMgr: CLLocationManager = CLLocationManager.init()
    /// 请求定位权限
    ///
    /// - Parameter type: 请求类型
    /// - Returns: true/false
    @discardableResult
    class func requestLocationAuthor(type: kLocationType = .whenInUse) -> Bool {
        
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
        
        if !self.requestAlbumAuthor() { return }
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
    
    //MARK: -请求图库权限 是否可以保存
    /// 请求图库权限 是否可以保存
    ///
    /// - Returns: true/false
    @discardableResult
    class func requestAlbumAuthor(block:(()->Void)? = nil) -> Bool {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                DispatchQueue.main.async {
                    AuthorityTool.requestAlbumAuthor()
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

