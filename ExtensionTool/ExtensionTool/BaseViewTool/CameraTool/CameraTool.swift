//
//  CameraTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/20.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

class CameraTool: NSObject {

    var dataList: [AlbumModel] = []
    
    class func gotoAlbum() {
        
        let cameraVC = CameraViewController()
        let nav = UINavigationController.init(rootViewController: cameraVC)
        
        kRootVC.present(nav, animated: true, completion: nil)
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
                
                let model = AlbumModel.init(title: title, fetchResult: result)
                self.dataList.append(model)
            }
        }
    }
}
