//
//  PhotoBrowerTool.swift
//  VideoClipDemo
//
//  Created by 张崇超 on 2018/6/8.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class PhotoBrowerTool: UIView {
    
    /// 翻转以后的屏幕宽高
    private var changeW: CGFloat = kWidth
    private var changeH: CGFloat = kHeight
    /// 传递过来的动画原始位置
    private var originalFrame: CGRect?
    /// 当前下标
    private var currentIndex: Int = 0
    /// 数据源
    private var dataList: [Any] = []
    /// 是否在执行动画
    private var isAnimating: Bool = false
    /// 父视图 执行缩小动画
    private var allSubViewsFrameArr: [CGRect]?
    private var baseView: UIView? {
        
        willSet {
            
            if newValue == nil { }
            
            self.allSubViewsFrameArr = []
            let allSubViews = newValue!.subviews
            for subView in allSubViews {
                
                let sub: UIView = subView
                let convertFrame = newValue?.convert(sub.frame, to: kWindow)
                self.allSubViewsFrameArr?.append(convertFrame!)
            }
        }
    }
    
    /// 展示图片
    ///
    /// - Parameters:
    ///   - imgArrs: 图片数组
    ///   - currentIndex: 当前下标 从0开始
    ///   - currentImg: 当前的图片
    ///   - originalFrame: 初始位置 基于屏幕
    ///   - baseView: 父视图
    static func showPhotoBrower(imgArrs: [Any], currentIndex: Int, baseView: UIView? = nil, currentImg: UIImage?, originalFrame: CGRect? = nil) {
        
        let tool = PhotoBrowerTool.init(imgsArr: imgArrs, currentIndex: currentIndex, original: originalFrame)
        tool.baseView = baseView
        
        // 添加动画View
        if let originalFrame = originalFrame {
            
            tool.falseImgV.frame = originalFrame
            tool.falseImgV.alpha = 1.0
            tool.falseImgV.image = currentImg
            kWindow.addSubview(tool.falseImgV)
            
            // 添加最终展示的View
            tool.alpha = 0.0
            kWindow.addSubview(tool)
            
            // 执行放大动画
            UIView.animate(withDuration: 0.2, animations: {
                
                tool.falseImgV.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
                
            }) { (isOk) in
                
                // 隐藏动画View
                tool.falseImgV.alpha = 0.0
                // 展示出最终View
                tool.alpha = 1.0
            }
        
        } else {
            
            if tool.isAnimating { return }
            tool.isAnimating = true
            
            tool.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            kWindow.addSubview(tool)
            UIView.animate(withDuration: 0.3, animations: {
                
                tool.transform = CGAffineTransform.identity
                
            }) { (isOk) in
                
                tool.isAnimating = false
            }
        }
    }
    
    /// 展示完成 移除
    func hiddenPhoto() {
        
        if let originalFrame = self.originalFrame {
            
            // 展示动画View
            self.falseImgV.alpha = 1.0
            // 执行缩小动画
            UIView.animate(withDuration: 0.2, animations: {
                
                if let arr = self.allSubViewsFrameArr {
                    
                    self.falseImgV.frame = arr[self.currentIndex]
                    
                } else {
                    
                    self.falseImgV.frame = originalFrame
                }
                
            }) { (isOK) in
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self.falseImgV.alpha = 0.0
                    
                }, completion: { (isOk) in
                    
                    self.falseImgV.removeFromSuperview()
                })
            }
            // 移除视图
            self.removeFromSuperview()
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                self.alpha = 0.0
                
            }) { (isOk) in
                
                // 移除视图
                self.removeFromSuperview()
            }
        }
    }
    
    convenience init(imgsArr: [Any], currentIndex: Int, original: CGRect? = nil) {
        self.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        
        self.frameChangeNoteAction()
        NotificationCenter.default.addObserver(self, selector: #selector(frameChangeNoteAction), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.originalFrame = original
        self.currentIndex = currentIndex
        self.dataList = imgsArr
        self.collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        self.addSubview(self.collectionView)
        self.addSubview(self.alertLabel)
        
        if imgsArr.count > 1 {
            
            self.alertLabel.text = "\(currentIndex + 1)/\(imgsArr.count)"
            self.addSubview(self.saveBtn)
        }
    }
    
    //MARK: -点击事件
    /// 图片点击事件
    @objc func tapAction() {
        
        
    }
    /// 屏幕发生变化
    @objc func frameChangeNoteAction() {
        
        UIView.animate(withDuration: 0.2) {
            
            let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let orient = UIDevice.current.orientation
            
            if orient == .portrait {
                
                self.changeW = kWidth
                self.changeH = kHeight
                self.collectionView.transform = CGAffineTransform.identity
                
                self.alertLabel.transform = CGAffineTransform.identity
                self.saveBtn.transform = CGAffineTransform.identity
                // 1/10
                self.alertLabel.frame = CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0)
                // 保存
                self.saveBtn.frame = CGRect.init(x: (kWidth - 60.0) / 2.0, y: kHeight - 30.0 - 30.0, width: 60.0, height: 30.0)
                
            } else if orient == .landscapeLeft || orient == .landscapeRight {
                
                self.changeW = kHeight
                self.changeH = kWidth
                var angle: CGFloat = CGFloat.pi / 2.0
                orient == .landscapeLeft ? (angle = CGFloat.pi / 2.0) : (angle = -CGFloat.pi / 2.0)
                self.collectionView.transform = CGAffineTransform.init(rotationAngle: angle)
                
                // 版本1
                self.alertLabel.transform = CGAffineTransform.init(rotationAngle: angle)
                self.saveBtn.transform = CGAffineTransform.init(rotationAngle: angle)
                if orient == .landscapeLeft {
                    
                    self.alertLabel.frame = CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0)
                    self.saveBtn.frame = CGRect.init(x: (kWidth - 30.0) / 2.0, y: kHeight - 30.0 - 60.0, width: 30.0, height: 60.0)
                    
                } else {
                    
                    self.alertLabel.frame = CGRect.init(x: (kWidth - 50.0) / 2.0, y: kHeight - 30.0 - 60.0, width: 50.0, height: 50.0)
                    self.saveBtn.frame = CGRect.init(x: (kWidth - 30.0 ) / 2.0, y: 40.0, width: 30.0, height: 60.0)
                }
                
                // 版本2
                //                if orient == .landscapeLeft {
                //
                //                    self.alertLabel.frame = CGRect.init(x: kWidth / 2.0 - 40.0, y: (kHeight - 50.0) / 2.0, width: kWidth, height: 50.0)
                //                    self.saveBtn.frame = CGRect.init(x: 0.0, y: (kHeight - 60.0) / 2.0, width: 60.0, height: 30.0)
                //
                //                } else {
                //
                //                    self.alertLabel.frame = CGRect.init(x: 0.0, y: (kHeight - 50.0) / 2.0, width: 80.0, height: 22.0)
                //                    self.saveBtn.frame = CGRect.init(x: kWidth - 60.0, y: (kHeight - 60.0) / 2.0, width: 60.0, height: 30.0)
                //                }
                //                self.alertLabel.transform = CGAffineTransform.init(rotationAngle: angle)
                //                self.saveBtn.transform = CGAffineTransform.init(rotationAngle: angle)
            }
            layout.itemSize = CGSize.init(width: self.changeW, height: self.changeH)
            self.collectionView.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint.init(x: self.changeW * CGFloat(self.currentIndex), y: 0.0), animated: false)
        }
    }
    
    @objc func saveAction() {
        
        // 权限问题
        let isOK = AuthorityTool.requestAlbumAuthor { [unowned self] in
            
            self.saveAction()
        }
        if !isOK { return }
        
        self.showLoading()
        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: self.currentIndex, section: 0)) as! PhotoBrowerCell
        if let img: UIImage = cell.imageView.image {
            
            AuthorityTool.saveMediaToAlbum(img: img) { [unowned self] (isOk) in
                if isOk {
                    
                    self.showText("保存成功")
                    
                } else {
                    
                    self.showText("保存失败")
                }
            }
            
        } else {
            
            self.showText("保存失败")
        }
        
    }
    
    //MARK: -懒加载
    /// 假的View,用于处理放大动画
    lazy var falseImgV: UIImageView = {
        let imgV: UIImageView = UIImageView.init()
        imgV.contentMode = .scaleAspectFit
        imgV.backgroundColor = UIColor.black
        
        return imgV
    }()
    /// 1/10
    lazy var alertLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.white
        
        return label
    }()
    /// 保存到相册
    lazy var saveBtn: UIButton = {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: (kWidth - 60.0) / 2.0, y: kHeight - 30.0 - 30.0, width: 60.0, height: 30.0)
        btn.setTitle("保存", for: .normal)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1.0
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.frame.width, height: self.frame.height)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(PhotoBrowerCell.self, forCellWithReuseIdentifier: "PhotoBrowerCell")
        
        return collection
    }()
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}

extension PhotoBrowerTool: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offSetY = scrollView.contentOffset.x
        let index = Int(offSetY / self.changeW)
        self.currentIndex = index
        self.alertLabel.text = "\(index + 1)/\(self.dataList.count)"
        
        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as! PhotoBrowerCell
        self.falseImgV.image = cell.imageView.image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowerCell", for: indexPath) as! PhotoBrowerCell
        cell.scrollView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.changeW, height: self.changeH)
        cell.scrollView.center = CGPoint.init(x: self.changeW / 2.0, y: self.changeH / 2.0)
        cell.imageView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.changeW, height: self.changeH)
        cell.imageView.center = CGPoint.init(x: self.changeW / 2.0, y: self.changeH / 2.0)
        
        let object = self.dataList[indexPath.row]
        if object is String {
            
            cell.imageView.image = UIImage.init(named: object as! String)

        } else if object is UIImage {
            
            cell.imageView.image = object as? UIImage
        }
        
        cell.clickCallBack = {
            
            self.hiddenPhoto()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? PhotoBrowerCell {
            
            cell.scrollView.zoomScale = 1.0
            cell.imageView.center = cell.scrollView.center
        }
    }
}

class PhotoBrowerCell: UICollectionViewCell {
    
    /// 滚动视图
    var scrollView:UIScrollView!
    var imageView:UIImageView!
    /// 单击回调
    var clickCallBack:()->Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    deinit {
        print("##### \(self)销毁了 #####")
    }
}

extension PhotoBrowerCell: UIScrollViewDelegate{
 
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


