//
//  ExtensionTool.swift
//  各种扩展
//
//  Created by 张崇超 on 2018/7/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 是否是iphoneX
var kIsIphoneX: Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    let arr = identifier.components(separatedBy: ",")
    if (arr.first ?? "") == "x86_64" {
        
        return kHeight > 736.0
    }
    return ((arr.first ?? "") == "iPhone10") && ((arr.last ?? "") == "3" || (arr.last ?? "") == "6")
}
/// 导航栏高度
let kNavBarHeight: CGFloat = kIsIphoneX ? (88.0) : (64.0)
/// 底部不可控区域
let kBottomSpace: CGFloat = kIsIphoneX ? (34.0) : (0.0)
/// 屏幕宽
let kWidth: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高
let kHeight: CGFloat = UIScreen.main.bounds.size.height
/// 主窗口
let kWindow: UIWindow = UIApplication.shared.keyWindow!
/// 根试图控制器
let kRootVC: UIViewController = kWindow.rootViewController!
/// AppDeleagte
let kAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
