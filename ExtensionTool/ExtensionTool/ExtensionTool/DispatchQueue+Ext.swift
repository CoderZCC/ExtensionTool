//
//  DispatchQueue+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    //MARK: 异步提交延迟操作到主线程
    /// 异步提交延迟操作到主线程
    ///
    /// - Parameters:
    ///   - dealyTime: 延迟时间 相对于当前时间
    ///   - callBack: 回调
    static func k_asyncAfterOnMain(dealyTime: Double, callBack: (()->Void)?) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dealyTime) {
            
            callBack?()
        }
    }
    
    //MARK: 异步提交延迟操作到全局子线程
    /// 异步提交延迟操作到全局子线程
    ///
    /// - Parameters:
    ///   - dealyTime: 延迟时间 相对于当前时间
    ///   - callBack: 回调
    func k_asyncAfterOnBack(dealyTime: Double, callBack: (()->Void)?) {
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + dealyTime) {
            
            callBack?()
        }
    }
}

var kNSObjectDelayKey: Int = 0

extension NSObject {
    
    /// 启动延迟操作
    ///
    /// - Parameters:
    ///   - afterDelay: 延迟时间
    ///   - block: 回调
    func k_startDelayTimer(afterDelay: TimeInterval, block:@escaping()->Void) {
        
        objc_setAssociatedObject(self, &kNSObjectDelayKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.perform(#selector(k_delayTimerAction), with: nil, afterDelay: afterDelay)
    }
    
    /// 取消延迟操作
    func k_stopDelayTimer() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(k_delayTimerAction), object: nil)
    }
    
    /// 延迟事件
    @objc func k_delayTimerAction() {
        
        (objc_getAssociatedObject(self, &kNSObjectDelayKey) as! (()->Void))()
    }
}
