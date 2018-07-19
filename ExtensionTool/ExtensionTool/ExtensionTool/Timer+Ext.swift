//
//  Timer+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/19.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var kTimerKey: Int = 0

extension NSObject {
    
    /// 存储定时器使用
    fileprivate var k_timers: [String: DispatchSourceTimer?]? {
        
        set {
            objc_setAssociatedObject(self, &kTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {  return objc_getAssociatedObject(self, &kTimerKey) as? [String: DispatchSourceTimer?] }
    }
    
    //MARK: 启动定时器
    /// 启动定时器
    ///
    /// - Parameters:
    ///   - timerIdentifier: 唯一的标记符, 如果同一个对象只有一个定时器 可以不传
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复 true一直运行 false运行一次
    ///   - block:  回调
    /// - Returns: 定时器
    func k_init(timerIdentifier: String? = nil, timeInterval: TimeInterval, repeats: Bool, block: @escaping (DispatchSourceTimer?)->Void) {
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: timeInterval)
        var count: Int = 0
        timer.setEventHandler { [unowned self] in
            
            if !repeats && count == 1 {
                
                self.k_invalidate(timerIdentifier: timerIdentifier)
                return
            }
            count += 1
            block(timer)
        }
        timer.resume()

        var timers = self.k_timers ?? [:]
        timers[timerIdentifier ?? "timer"] = timer
        self.k_timers = timers
    }
    
    //MARK: 销毁定时器
    /// 销毁定时器
    ///
    /// - Parameter timerIdentifier: 定时器唯一标记符
    func k_invalidate(timerIdentifier: String? = nil) {
        
        let key = timerIdentifier ?? "timer"
        var timers = self.k_timers ?? [:]
        if let timer = timers[key] {
            timer?.cancel()
            timers[key] = nil
        }
        timers.removeValue(forKey: key)
        self.k_timers = timers
        
        if timers.isEmpty { self.k_timers = nil }
    }
    
}
