//
//  ExtensionTool.swift
//  各种扩展
//
//  Created by 张崇超 on 2018/7/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 是否是iphoneX 是否有安全区域
var kIsIphoneX: Bool!
/// 主窗口
var kWindow: UIWindow!
/// 根试图控制器
var kRootVC: UIViewController!

/// AppDeleagte
let kAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
/// 标签栏高度
let kTabBarHeight: CGFloat = kIsIphoneX ? (49.0 + 34.0) : (49.0)
/// 导航栏高度
let kNavBarHeight: CGFloat = kIsIphoneX ? (64.0 + 20.0) : (64.0)
/// 底部不可控区域
let kBottomSpace: CGFloat = kIsIphoneX ? (34.0) : (0.0)
/// 顶部不可控区域
let kTopSpace: CGFloat = kIsIphoneX ? (44.0) : (0.0)
/// 屏幕宽
let kWidth: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高
let kHeight: CGFloat = UIScreen.main.bounds.size.height

/// 系统版本
let kVersion: Double = Double(UIDevice.current.systemVersion.components(separatedBy: ".").first ?? "0") ?? 0.0

