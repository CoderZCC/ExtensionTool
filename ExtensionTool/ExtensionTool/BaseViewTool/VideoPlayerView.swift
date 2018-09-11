//
//  VideoPlayer.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import AVKit

protocol VideoPlayerDelegate: NSObjectProtocol {
    
    func videoPlayerCaching()
    
    func videoPlayerReadyToPlay()
}

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
            playerLayer.videoGravity = .resizeAspectFill

            self.playerLayer = playerLayer
            self.player = player
            // 添加监听
            self.addObserver()
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
    
    // MARK: -重写
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
            
            let wh: CGFloat = 40.0
            self.loadingView.isHidden = true
            self.loadingView.frame = CGRect(x: min(newValue.width, kWidth) - wh, y: min(newValue.height, kHeight) - wh, width: wh, height: wh)
            DispatchQueue.k_asyncAfterOnMain(dealyTime: 0.5) {
                
                self.loadingView.isHidden = false
            }
        }
    }
    
    /// 准备播放
    func readyToPlay() {
        
        self.isReadyToPlay = { [unowned self] in
            
            self.player?.play()
            self.isPlaying = true
            self.isResume = true
        }
    }
    
    /// 暂停播放
    func pausePlayer() {
        
        self.isPlaying = false
        self.player?.pause()
        self.launchImageView.isHidden = true
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
    /// 是否可以播放
    private var isReadyToPlay: (()->Void)?
    
    private lazy var loadingView: UIView = {
        let wh: CGFloat = 40.0
        let view = UIView.init(frame: CGRect(x: self.frame.width - wh, y: self.frame.height - wh, width: wh, height: wh))
        view.addSubview(self.pauseImgV)
        view.addSubview(self.playImgV)
        view.addSubview(self.loadingImgV)

        return view
    }()
    lazy var loadingImgV: UIImageView = {
        let imgV = UIImageView.init(image: #imageLiteral(resourceName: "loading"))
        
        return imgV
    }()
    lazy var pauseImgV: UIImageView = {
        let imgV = UIImageView.init(image: #imageLiteral(resourceName: "stop"))
        imgV.isHidden = true
        imgV.k_addTarget({ [unowned self] (tap) in
            
            imgV.isHidden = true
            self.loadingImgV.isHidden = true
            self.playImgV.isHidden = false
            self.pausePlayer()
        })
        
        return imgV
    }()
    lazy var playImgV: UIImageView = {
        let imgV = UIImageView.init(image: #imageLiteral(resourceName: "play"))
        imgV.isHidden = true
        imgV.k_addTarget({ [unowned self] (tap) in
            
            imgV.isHidden = true
            self.loadingImgV.isHidden = true
            self.pauseImgV.isHidden = false
            self.player?.play()
            self.isPlaying = true
            self.isResume = true
        })
        
        return imgV
    }()
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        self.removeObserver()
        print("###\(self)销毁了###\n")
    }
}

//MARK : -私有方法
extension VideoPlayerView {
    
    /// 初始化
    private func setup() {
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundNote), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundNote), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        self.addSubview(self.launchImageView)
        self.addSubview(self.loadingView)
    }
    
    /// 添加监听
    private func addObserver() {
        
        let item = self.player?.currentItem
        //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        item?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 监控网络加载情况属性
        item?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听播放的区域缓存是否为空
        item?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
        // 缓存可以播放的时候调用
        item?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
    }
    /// 移除监听
    private func removeObserver() {
        
        let item = self.player?.currentItem
        item?.removeObserver(self, forKeyPath: "status")
        item?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        item?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        item?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
    /// 监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let changeDic = change else { return }
        
        switch keyPath {
        case "status":
            
            let status = (changeDic[.newKey] as! NSNumber).intValue
            if status == AVPlayerStatus.readyToPlay.rawValue {
                
                if self.isPlaying { return }
                
                self.launchImageView.isHidden = true
                self.layer.addSublayer(self.playerLayer!)
                self.bringSubview(toFront: self.loadingView)
                
                self.isReadyToPlay?()
                
                self.loadingImgV.isHidden = true
                self.playImgV.isHidden = true
                self.pauseImgV.isHidden = false
                print("准备播放")

            } else if status == AVPlayerStatus.failed.rawValue {
                
                print("播放失败")
                
            } else if status == AVPlayerStatus.unknown.rawValue {
                
                print("未知错误")
            }
            
        case "loadedTimeRanges":
            
//            guard let playItem = object as? AVPlayerItem else { return }
//            let arr = playItem.loadedTimeRanges
//            let timeRange: CMTimeRange = arr.first!.timeRangeValue
//
//            let startSeconds = timeRange.start.seconds
//            let durationSeconds = timeRange.duration.seconds
//            // 缓冲总长度
//            let totalBuffer = startSeconds + durationSeconds
//            print("缓冲长度:\(totalBuffer)")
            
            // 加载
            
            
            break
            
        case "playbackBufferEmpty":
            
            print("缓存为空")
            // 开始加载
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber.init(value: Double.pi * 2.0)
            rotationAnimation.duration = 0.6
            // 旋转累加角度
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = Float(Int.max)
            self.loadingImgV.layer.add(rotationAnimation, forKey: "rotationAnimation")
            
        case "playbackLikelyToKeepUp":
            
            print("缓存可以播放")
            self.loadingImgV.layer.removeAnimation(forKey: "rotationAnimation")

        default:
            break
        }        
    }
    
    // MARK: -通知事件
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

