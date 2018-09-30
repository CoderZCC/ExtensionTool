//
//  ShareTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/30.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

struct ShareStruct {
    
    /// 标题
    var title: String?
    /// 文本内容
    var content: String?
    /// 分享链接
    var shareUrl: String?
    /// 封面图片
    var coverImgUrl: String?
    
    /// 是否已收藏 默认为 未收藏
    var isCollection: Bool = false {
        willSet {
            
            ShareTool.tupleArr[5] = newValue ? ("share_collectioned", "已收藏", UMSocialPlatformType.unKnown) : ("share_collection", "收藏", UMSocialPlatformType.unKnown)
        }
    }
    /// 下载地址
    var downloadUrl: String?
}

enum ShareType {
    case normal, moreBtn
}

enum ShareResultType {
    case success, fail, cancle
    case collection
    case download
    case report
}

enum UMSocialPlatformType {
    case sina, wechatSession, wechatTimeLine, qzone, QQ, unKnown
}

class ShareTool: UIView {

    class func show(_ type: ShareType = .normal, shareStruct: ShareStruct, block: ((ShareResultType)->Void)? = nil) {
        
        if ShareTool.isAlearlyExit { return }
        let tool = ShareTool.init(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(tool)

        tool.createBtns(type)
        tool.block = block
        tool.shareStruct = shareStruct
    }
    
    /// 是否已经存在
    static var isAlearlyExit: Bool {
        
        return UIApplication.shared.keyWindow?.viewWithTag(1001) != nil
    }
    
    /// 事件回调
    private var block: ((ShareResultType)->Void)?
    // MARK: -数据源
    static var tupleArr:[(img: String, text: String, type: UMSocialPlatformType)] = [
        ("share_sina", "微博", UMSocialPlatformType.sina),
        ("share_wechat", "微信", UMSocialPlatformType.wechatSession),
        ("share_circle", "朋友圈", UMSocialPlatformType.wechatTimeLine),
        ("share_qqkj", "QQ空间", UMSocialPlatformType.qzone),
        ("share_qq", "QQ", UMSocialPlatformType.QQ),
        ("share_collection", "收藏", UMSocialPlatformType.unKnown),
        ("share_download", "保存本地", UMSocialPlatformType.unKnown),
        ("share_report", "举报", UMSocialPlatformType.unKnown)]
    /// 真正展示的数据源
    private var dataList: [(img: String, text: String, type: UMSocialPlatformType)]!
    /// 传递的数据
    private var shareStruct: ShareStruct!
    
    // MARK: -顶部标题设置
    private let topTitleText: String = "———  分享至  ———"
    private let topTitleHeight: CGFloat = 35.0
    private let topTitleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    private let topTitleColor: UIColor = UIColor.black
   
    // MARK: -内容设置
    private var contentHeight: CGFloat!
    private let signleWidth: CGFloat = UIScreen.main.bounds.width / 5.0
    private let signleHeight: CGFloat = 100.0
    private let contentColor: UIColor = UIColor.black
    private let contentFont: UIFont = UIFont.systemFont(ofSize: 12.0)

    // MARK: -取消按钮设置
    private let cancleText: String = "取消"
    private let cancleHeight: CGFloat = 44.0
    private let cancleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    private let cancleColor: UIColor = UIColor.black
    private let seportColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6)
    
    // MARK: -安全区域设置
    private let safeHeight: CGFloat = UIScreen.main.bounds.height >= 812.0 ? (34.0) : (0.0)
    private let safeColor: UIColor = UIColor.white
    
    private var showType: ShareType! {
        willSet {
            
            if newValue == .normal {
                
                self.contentHeight = 100.0
                self.dataList = []
                for i in 0...4 {
                    
                    self.dataList.append(ShareTool.tupleArr[i])
                }
                
            } else {
                
                self.contentHeight = 200.0
                self.dataList = ShareTool.tupleArr
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0.0
        self.tag = 1001
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.hidenView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 隐藏方法
    private func hidenView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)

        }) { (isOk) in
            
            for subView in self.contentView.subviews { subView.removeFromSuperview() }
            for subView in self.subviews { subView.removeFromSuperview() }
            self.removeFromSuperview()
        }
    }
    
    /// 创建按钮组
    private func createBtns(_ type: ShareType) {
        
        self.showType = type
        
        self.addSubview(self.showView)
        self.showView.addSubview(self.topTitleL)
        self.showView.addSubview(self.contentView)
        self.showView.addSubview(self.cancleTitleL)
        self.showView.addSubview(self.safeAreaView)

        var index: CGFloat = 0.0
        var btnY: CGFloat = 0.0
        for (tapNum, tuple) in self.dataList.enumerated() {
            
            if index == 5 {
                
                btnY = 100.0
                index = 0
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: self.signleWidth * index, y: btnY, width: self.signleWidth, height: self.signleHeight)
            index += 1
            btn.tag = tapNum
            btn.setTitleColor(self.contentColor, for: .normal)
            btn.titleLabel?.font = self.contentFont
            btn.st_setBtn(image: UIImage(named: tuple.img), title: tuple.text, titlePosition: .bottom, spacing: 0.0, state: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: btn.imageEdgeInsets.top, left: btn.imageEdgeInsets.left, bottom: btn.imageEdgeInsets.bottom + 20.0, right: btn.imageEdgeInsets.right)
            btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            
            self.addSpringAnimation(to: btn)
            
            self.contentView.addSubview(btn)
        }
        
        self.showView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.25, animations: {
          
            self.alpha = 1.0
            self.showView.transform = CGAffineTransform.identity
        })
    }
    
    /// 添加弹簧动画
    private func addSpringAnimation(to btn: UIButton) {
        
        btn.layer.removeAllAnimations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(Double(btn.tag > 4 ? (btn.tag - 4) : (btn.tag)) * 0.05)) {
            
            let springAni = CASpringAnimation(keyPath: "position.y")
            springAni.duration = springAni.settlingDuration
            springAni.damping = 10.0
            springAni.mass = 1
            springAni.initialVelocity = 0
            springAni.stiffness = 100
            
            springAni.fromValue = btn.layer.position.y - 30.0
            springAni.toValue = btn.layer.position.y
            
            btn.layer.add(springAni, forKey: "springAni")
        }
    }
    
    // MARK: -Lazy
    private lazy var showView: UIView = {
        let height: CGFloat = self.topTitleHeight + self.cancleHeight + self.contentHeight + self.safeHeight
        let view = UIView(frame: CGRect(x: 0.0, y: self.bounds.height - height, width: self.bounds.width, height: height))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var topTitleL: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.topTitleHeight))
        label.backgroundColor = UIColor.white
        label.textAlignment = .center

        label.text = self.topTitleText
        label.font = self.topTitleFont
        label.textColor = self.topTitleColor

        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.topTitleL.frame.maxY, width: self.bounds.width, height: self.contentHeight))
        view.backgroundColor = UIColor.white
        if self.showType == .moreBtn {
            
            view.st_addLine(with: self.seportColor, at: CGRect(x: 0.0, y: self.signleHeight, width: view.frame.width, height: 0.5))
        }

        return view
    }()

    private lazy var cancleTitleL: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.contentView.frame.maxY, width: self.bounds.width, height: self.cancleHeight))
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.cancleHeight))
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        
        label.text = self.cancleText
        label.font = self.cancleFont
        label.textColor = self.cancleColor
        
        view.addSubview(label)
        view.st_addLine(with: self.seportColor, at: CGRect(x: 0.0, y: 0.0, width: label.frame.width, height: 0.5))
        
        return view
    }()

    private lazy var safeAreaView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.cancleTitleL.frame.maxY, width: self.bounds.width, height: self.safeHeight))
        view.backgroundColor = self.safeColor
        
        return view
    }()
    
    deinit {
        debugPrint("\(self)销毁了")
    }
}

extension ShareTool {
    
    /// 按钮点击事件
    @objc private func btnAction(btn: UIButton) {
        
        self.hidenView()
        if btn.tag <= 5 {
            
            let tuple = self.dataList[btn.tag]
            print("\(tuple.text)")
            self.block?(.success)
            
        } else {
            
            switch btn.tag {
            case 5:
                
                self.block?(.collection)
                
            case 6:
                
                self.block?(.download)
                
            case 7:
                
                self.block?(.report)
                
            default:
                break
            }
        }
    }
}

extension UIView {
    
    func st_addLine(with color: UIColor, at: CGRect) {
        
        let layer = CAShapeLayer()
        layer.backgroundColor = color.cgColor
        layer.frame = at
        
        self.layer.addSublayer(layer)
    }
}

extension UIButton {
    
    func st_setBtn(image: UIImage?, title: String, titlePosition: UIView.ContentMode, spacing: CGFloat = 5.0, state: UIControl.State = .normal) {
        
        self.imageView?.contentMode = .center
        self.setImage(image, for: state)
        
        self.st_positionLabelRespectToImage(title: title, position: titlePosition, spacing: spacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    fileprivate func st_positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 14.0)
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        var titleInsets: UIEdgeInsets!
        var imageInsets: UIEdgeInsets!
        
        switch (position){
        case .top:
            
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            
        case .bottom:
            
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: -titleSize.width)
            
        case .left:
            
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            
        case .right:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets.zero
            
        default:
            
            titleInsets = UIEdgeInsets.zero
            imageInsets = UIEdgeInsets.zero
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
