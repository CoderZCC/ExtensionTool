//
//  VideoPlayer.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayer: AVPlayer {
    
    /// 视频总时长
    var totalDuration: CGFloat!
    /// 视频显示层
    var playerLayer: AVPlayerLayer!
    /// 是否进入后台的回调
    var isEnterBackground: ((_ isEnter: Bool)->Void)?
    /// 是否无限轮播
    var isRunPlay: Bool = false {
        
        willSet {
            
            if newValue {
                
                self.play()
                NotificationCenter.default.addObserver(self, selector: #selector(playEndNote), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    /// 是否在返回时播放视频
    private var isResume: Bool = false
    /// 是否在播放
    private var isPlaying: Bool = false
    
    convenience init(frame: CGRect, videoUrl: URL) {
        // 初始化播放器
        let item = AVPlayerItem.init(url: videoUrl)
        self.init(playerItem: item)
        
        // 视频时长
        self.totalDuration = videoUrl.getVideoDuration()
        
        let playerLayer = AVPlayerLayer.init(player: self)
        playerLayer.frame = frame
        playerLayer.videoGravity = .resizeAspect
        self.playerLayer = playerLayer
        
        self.volume = 0.5
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(resumePlay), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pausePlay), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func play() {
        super.play()
        self.isPlaying = true
    }
    
    /// 继续播放
    @objc func resumePlay() {
        
        self.isEnterBackground?(false)
        if self.isResume {
            
            self.play()
        }
    }
    
    /// 暂停播放
    @objc func pausePlay() {
        
        self.isEnterBackground?(true)
        if self.isPlaying {
            self.isResume = true
        }
        self.pause()
    }
    
    /// 播放结束的通知
    @objc func playEndNote() {
        
        if self.isRunPlay {
            
            self.pausePlay()
            self.seekTimeToPlay(time: 0.0) { (isOK) in
                
                self.play()
            }
        }
    }
    
    /// 销毁播放器
    func destoryPlayer() {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension AVPlayer {
    
    /// 快进到指定时间
    ///
    /// - Parameters:
    ///   - time: 时间
    ///   - isFinsish: 是否快进到,并且准备播放
    func seekTimeToPlay(time: CGFloat, isFinsish: ((_ isFinish: Bool) ->Void)? ) {
        
        let time = CMTime.init(seconds: Double(time), preferredTimescale: CMTimeScale(1 * NSEC_PER_SEC))
        self.seek(to: time, toleranceBefore: CMTime.init(value: 1, timescale: 30), toleranceAfter: CMTime.init(value: 1, timescale: 30)) { (isOk) in
            
            isFinsish?((isOk && self.status == .readyToPlay))
        }
    }
}

extension CMTime {
    
    /// 转为float数
    ///
    /// - Returns: 时间
    func toFloat() -> CGFloat {
        return CGFloat(CMTimeGetSeconds(self))
    }
}

extension URL {
    
    /// 根据地址获取视频时长
    ///
    /// - Returns: 视频时长
    func getVideoDuration() -> CGFloat {
        
        let urlAsset = AVURLAsset.init(url: self)
        return urlAsset.duration.toFloat()
    }
}
