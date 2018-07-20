//
//  PreviewViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/19.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

class PreviewViewController: UIViewController {

    fileprivate var callBack: ((UIImage) -> Void)?
    fileprivate var img: UIImage!
    fileprivate var isClip: Bool!
    fileprivate let clipRect: CGRect = CGRect.init(x: 0.0, y: (kHeight - kWidth) / 2.0, width: kWidth, height: kWidth)
    
    convenience init(img: UIImage, isClip: Bool, block: ((UIImage) -> Void)?) {
        self.init(nibName: nil, bundle: nil)
        self.img = img
        self.isClip = isClip
        self.callBack = block
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupSubViews()
    }
    
    //MARK: 设置导航栏
    func setupNavigation() {
        
    }
    
    //MARK: 初始化子视图
    func setupSubViews() {
        
        self.view.addSubview(self.scrollView)
        if self.isClip {
            
            self.scrollViewDidZoom(self.scrollView)
            self.view.addSubview(self.maskView)
        }
        self.view.addSubview(self.topView)
        self.view.addSubview(self.bottomView)
        
        // 双击监听
        let tapDouble = UITapGestureRecognizer(target:self, action:#selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        self.imgV.addGestureRecognizer(tapDouble)
    }
    
    //MARK: 事件
    // 图片双击事件响应
    @objc func tapDoubleDid(_ ges:UITapGestureRecognizer){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
            if let weakSelf = weakSelf {
                
                // 如果当前不缩放，则放大到3倍。否则就还原
                if weakSelf.scrollView.zoomScale == 1.0 {
                    
                    // 以点击的位置为中心，放大3倍
                    let pointInView = ges.location(in: self.imgV)
                    let newZoomScale:CGFloat = 3
                    let scrollViewSize = weakSelf.scrollView.bounds.size
                    let w = scrollViewSize.width / newZoomScale
                    let h = scrollViewSize.height / newZoomScale
                    let x = pointInView.x - (w / 2.0)
                    let y = pointInView.y - (h / 2.0)
                    let rectToZoomTo = CGRect(x:x, y:y, width:w, height:h)
                    weakSelf.scrollView.zoom(to: rectToZoomTo, animated: true)
                    
                } else {
                    
                    weakSelf.scrollView.zoomScale = 1.0
                }
            }
        })
    }
    
    //MARK: 懒加载
    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView.init(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.black
        
        if self.isClip {
            
            scrollView.delegate = self
            scrollView.alwaysBounceVertical = true
            scrollView.maximumZoomScale = 3.0
            scrollView.minimumZoomScale = 1.0
        }
        scrollView.addSubview(self.imgV)

        return scrollView
    }()
    lazy var imgV: UIImageView = { [unowned self] in
        let imgV = UIImageView.init(frame: self.view.bounds)
        imgV.contentMode = .scaleAspectFit
        imgV.image = self.img
        imgV.isUserInteractionEnabled = true
        
        return imgV
    }()
    
    lazy var maskView: UIView = { [unowned self] in
        let maskView = UIView.init(frame: self.view.bounds)
        maskView.isUserInteractionEnabled = false
        maskView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor

        let clipLayer = CAShapeLayer.init()
        maskView.layer.addSublayer(clipLayer)

        // 白框
        let whitePath = UIBezierPath.init(rect: CGRect.init(x: self.clipRect.origin.x, y: self.clipRect.origin.y - 1.0, width: self.clipRect.size.width, height: self.clipRect.size.height + 2.0))

        let whiteLayer = CAShapeLayer.init()
        whiteLayer.path = whitePath.cgPath
        whiteLayer.fillColor = UIColor.clear.cgColor
        whiteLayer.strokeColor = UIColor.white.cgColor
        maskView.layer.addSublayer(whiteLayer)

        let alphaPath = UIBezierPath.init(rect: maskView.bounds)
        let rectPath = UIBezierPath.init(rect:  CGRect.init(x: self.clipRect.origin.x + 1.5, y: self.clipRect.origin.y - 0.5, width: self.clipRect.size.width - 3.0, height: self.clipRect.size.height + 1.0))
        alphaPath.append(rectPath)

        let layer = CAShapeLayer.init()
        layer.path = alphaPath.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        maskView.layer.mask = layer
        
        return maskView
    }()
    
    lazy var topView: UIView = { [unowned self] in
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.k_width, height: kNavBarHeight))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let imgWH: CGFloat = 20.0
        let imgV = UIImageView.init(frame: CGRect.init(x: 12.0, y: kNavBarHeight - imgWH - 10.0, width: imgWH, height: imgWH))
        imgV.image = #imageLiteral(resourceName: "back")
        imgV.k_addTarget({ (tap) in
            
            if let nav = self.navigationController {
                
                nav.popViewController(animated: true)

            } else {
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        view.addSubview(imgV)
        return view
    }()
    lazy var bottomView: UIView = { [unowned self] in
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: kHeight - 44.0 - kBottomSpace, width: self.view.k_width, height: 44.0 + kBottomSpace))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let label = UILabel.init(frame: CGRect.init(x: view.k_width - 95.0, y: 0.0, width: 80.0, height: 44.0))
        label.text = "完成"
        label.textColor = UIColor.green
        label.textAlignment = .right
        view.addSubview(label)
        
        label.k_addTarget({ (tap) in
            
            if self.isClip {
                
                let screenSnap = UIImage.k_screenSnap()
                let newImg = screenSnap.k_cropImageWith(newSize: self.clipRect.size)
                self.callBack?(newImg)
            }
            self.callBack?(self.img)
            if self.navigationController == nil {
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        return view
    }()
    
    //MARK: 重写
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print("\n====== \(self) 销毁了======\n")
    }
}

extension PreviewViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imgV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:centerY
        self.imgV.center = CGPoint(x: centerX, y: centerY)
        
        // 设置图片可以拖下来,可以推上去
        if scrollView.zoomScale == 1.0 {
            
            // 计算内容
            var scale = self.img.size.width / self.img.size.height
            scale = min(1.0, scale)
            let height = kWidth / scale
            let topNum: CGFloat = (height - kWidth) / 2.0
            
            scrollView.contentSize = CGSize.init(width: 0.0, height: kHeight + topNum)
            scrollView.contentInset = UIEdgeInsetsMake(topNum - 20.0, 0.0, 0.0, 0.0)
        }
    }
    
}
