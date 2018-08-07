//
//  VideoPlayer.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    
    //MARK: -调用部分
    /// 是否在播放
    var isPlaying: Bool = false
    /// 播放器
    var player: AVPlayer?
    /// 播放器layer
    var playerLayer: AVPlayerLayer?
    
    /// 占位图片
    lazy var launchImageView: UIImageView = {
        let imgV = UIImageView.init(frame: self.bounds)
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        
        return imgV
    }()
    /// 视频播放地址
    var videoUrl: String = "" {
        
        willSet {
            
            guard let url = URL.init(string: newValue) else { return }
            // 初始化播放器
            let item = AVPlayerItem.init(url: url)
            let player = AVPlayer.init(playerItem: item)
            
            let playerLayer = AVPlayerLayer.init(player: player)
            playerLayer.frame = self.bounds
            //playerLayer.videoGravity = .resizeAspect
            playerLayer.videoGravity = .resizeAspectFill
            
            self.playerLayer = playerLayer
            self.player = player
        }
    }
    /// 是否无限轮播
    var isRunPlay: Bool = false {
        
        willSet {
            
            if newValue {
            
                NotificationCenter.default.addObserver(self, selector: #selector(playEndNote), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override var frame: CGRect {
        willSet {
            
            self.launchImageView.frame = CGRect(x: 0.0, y: 0.0, width: newValue.width, height: newValue.height)
            self.playerLayer?.frame = self.launchImageView.bounds
        }
    }
    
    /// 准备播放
    func readyToPlay() {
        
        if self.isPlaying { return }
        self.layer.addSublayer(self.playerLayer!)
        self.player?.play()
        self.isPlaying = true
        self.isResume = true
        
        UIView.animate(withDuration: 0.25) {
            
            self.launchImageView.alpha = 0.0
        }
    }
    
    /// 销毁播放器
    func destoryPlayer() {
        
        if self.isPlaying {
            
            self.player?.pause()
            self.isPlaying = false
        }
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -实现部分
    /// 是否在返回时播放视频
    private var isResume: Bool = false
    
    /// 初始化
    private func setup() {
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundNote), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundNote), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        self.addSubview(self.launchImageView)
    }
    
    /// 进入前台
    @objc private func enterForegroundNote() {
        
        if self.isResume {
            
            self.player?.play()
        }
    }
    
    /// 进入后台
    @objc private func enterBackgroundNote() {
        
        if self.isPlaying {
            
            self.player?.pause()
        }
    }
    
    /// 播放结束的通知
    @objc private func playEndNote() {
        
        if self.isRunPlay {
            
            self.player?.pause()
            self.player?.seekTimeToPlay(time: 0.0) { [unowned self] (isOK) in

                self.player?.play()
            }
            
        } else {
            
            self.isPlaying = false
        }
    }
    
    deinit {
        print("###\(self)销毁了###\n")
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
        self.seek(to: time, toleranceBefore: CMTime.init(value: 1, timescale: 30), toleranceAfter: CMTime.init(value: 1, timescale: 30)) { [unowned self] (isOk) in
            
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
