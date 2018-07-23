//
//  CameraPreviewViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/23.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

class CameraPreviewViewController: UIViewController {

    var indexPath: IndexPath!
    var thumbImg: UIImage?
    var dataList: [PHAsset]!
    fileprivate let clipRect: CGRect = CGRect.init(x: 0.0, y: (kHeight - kWidth) / 2.0, width: kWidth, height: kWidth)
    var imgLoadFinish: (()->Void)?
    var currentImg: UIImage!
    
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
        
        self.view.addSubview(self.collectionView)
       
        self.view.addSubview(self.maskView)
        self.view.addSubview(self.topView)
        self.view.addSubview(self.bottomView)
        
        self.collectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //MARK: 事件
    
    
    //MARK: 懒加载
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.k_registerCell(cls: CameraPreviewCell.self)
        collectionView.isPagingEnabled = true
        
        collectionView.contentOffset = CGPoint.zero
        collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        layout.itemSize = CGSize(width: collectionView.k_width, height: collectionView.k_height - 1.0)
        
        return collectionView
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
        
        let clickView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: kNavBarHeight, height: kNavBarHeight))
        let imgWH: CGFloat = 20.0
        let imgV = UIImageView.init(frame: CGRect.init(x: 12.0, y: kNavBarHeight - imgWH - 10.0, width: imgWH, height: imgWH))
        imgV.image = #imageLiteral(resourceName: "back")
        clickView.k_addTarget({ (tap) in
            
            if let nav = self.navigationController {
                
                nav.popViewController(animated: true)
                
            } else {
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        clickView.addSubview(imgV)
        
        view.addSubview(clickView)
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
            
            let screenSnap = UIImage.k_screenSnap()
            let newImg = screenSnap.k_cropImageWith(newSize: self.clipRect.size)

            let vc = kRootVC.presentedViewController as! UINavigationController
            let cameraVC = vc.viewControllers.first as! CameraViewController
            cameraVC.block?(newImg)
            
            vc.dismiss(animated: true, completion: nil)
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

extension CameraPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.k_dequeueReusableCell(cls: CameraPreviewCell.self, indexPath: indexPath) as! CameraPreviewCell
        // 缩略图
        if self.thumbImg != nil { cell.imageView.image = self.thumbImg }
        // 高清图
        let asset = self.dataList[indexPath.row]
        let options = PHImageRequestOptions.init()
        options.resizeMode = .fast
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (img, dic) in
            
            cell.imageView.image = img
            self.thumbImg = nil
            self.imgLoadFinish?()
            self.currentImg = cell.imageView.image
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CameraPreviewCell {
            
            cell.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: false)
            cell.scrollView.zoomScale = 1.0
            
            if let img = cell.imageView.image {
                
                self.currentImg = img
                cell.setScrollViewModel()
            }
            self.imgLoadFinish = {
                
                cell.setScrollViewModel()
            }
        }
    }
}

class CameraPreviewCell: UICollectionViewCell {
    
    /// 滚动视图
    var scrollView:UIScrollView!
    var imageView:UIImageView!
    /// 单击回调
    var clickCallBack:()->Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        imageView = UIImageView.init(frame: scrollView.bounds)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        // 单击监听
        let scrollClick = UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
        scrollClick.numberOfTapsRequired = 1
        scrollClick.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(scrollClick)
        
        // 单击监听
        let tapSingle = UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        
        // 双击监听
        let tapDouble = UITapGestureRecognizer(target:self, action:#selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        
        // 声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
    }
    
    // 设置图片可以拖下来,可以推上去
    func setScrollViewModel() {
        
        // 计算内容
        if let img = self.imageView.image {
            
            var scale = img.size.width / img.size.height
            scale = min(1.0, scale)
            let height = kWidth / scale
            let topNum: CGFloat = (height - kWidth) / 2.0
            self.scrollView.contentSize = CGSize.init(width: 0.0, height: kHeight + topNum)
            self.scrollView.contentInset = UIEdgeInsetsMake(topNum - 20.0, 0.0, 0.0, 0.0)
        }
    }
    
    // 图片单击事件响应
    @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
        
        self.clickCallBack()
    }
    // 图片双击事件响应
    @objc func tapDoubleDid(_ ges:UITapGestureRecognizer){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
            if let weakSelf = weakSelf {
                
                // 如果当前不缩放，则放大到3倍。否则就还原
                if weakSelf.scrollView.zoomScale == 1.0 {
                    
                    // 以点击的位置为中心，放大3倍
                    let pointInView = ges.location(in: self.imageView)
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}

extension CameraPreviewCell: UIScrollViewDelegate {
    
    // 缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    // 缩放响应，设置imageView的中心位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:centerY
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
