//
//  PhotoBrowserTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/28.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class PhotoBrowserTool: UIView {
    
    static var placeholderImg: UIImage?
    /// 展示大图
    ///
    /// - Parameters:
    ///   - containerView: 父视图(集合视图/表视图/UIView/nil)
    ///   - imgArr: 图片数组
    ///   - currentIndex: 当前下标
    ///   - currentImg: 当前图片
    class func showImage(with containerView: UIView?, imgArr: [String], currentIndex: Int, currentImg: UIImage?) {
        
        let tool = PhotoBrowserTool(frame: UIScreen.main.bounds)
        // 赋值
        tool.containerView = containerView
        tool.imgArr = imgArr
        tool.currentIndex = currentIndex
        tool.currentImg = currentImg
        
        // 放大动画
        tool.showFirstImage()
        
        // 添加控件
        tool.addSubview(tool.alertLabel)
        if imgArr.count > 1 {
            
            tool.alertLabel.text = "\(currentIndex + 1)/\(imgArr.count)"
            tool.addSubview(tool.saveBtn)
        }
        
        // 接收屏幕旋转通知
        tool.frameChangeNoteAction()
        NotificationCenter.default.addObserver(tool, selector: #selector(frameChangeNoteAction), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        kWindow.addSubview(tool)
    }
    
    /// 容器
    private var containerView: UIView?
    /// 下标
    private var currentIndex: Int!
    /// 数组
    private var imgArr: [String]!
    /// 图片
    private var currentImg: UIImage?
    /// 是否执行动画
    private var isAnimating: Bool = false
    /// layout
    private var layout: UICollectionViewFlowLayout {
        
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    /// 是否横屏
    private var isHorizonShow: Bool?
    /// 是否已经翻转过
    private var isChanged: Bool = false
    /// 翻转以后的屏幕宽高
    private var changeW: CGFloat = kWidth
    private var changeH: CGFloat = kHeight
    
    /// 展示
    private func showFirstImage() {
        
        if self.isAnimating { return }
        if let scrollView = self.containerView as? UIScrollView {
            
            self.isAnimating = true
            // 添加集合视图
            self.collectionView.isHidden = true
            self.addSubview(self.collectionView)
            // 滚动到指定区域
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            // 假的图片
            let falseImageView = UIImageView()
            falseImageView.contentMode = .scaleAspectFit
            falseImageView.frame = self.originalRectWith(scrollView)
            falseImageView.image = self.currentImg
            self.addSubview(falseImageView)
            
            UIView.animate(withDuration: 0.3, animations: {

                self.backgroundColor = UIColor.black
                falseImageView.center = self.center
                falseImageView.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)

            }) { (isOK) in

                self.isAnimating = false
                falseImageView.isHidden = true
                falseImageView.removeFromSuperview()
                self.collectionView.isHidden = false
            }
            
        } else {
            
            self.isAnimating = true
            self.addSubview(self.collectionView)
            // 滚动到指定区域
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            
            self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.25, animations: {
                
                self.backgroundColor = UIColor.black
                self.transform = CGAffineTransform.identity
                
            }) { (isOk) in
                
                self.isAnimating = false
            }
        }
    }
    
    /// 隐藏
    private func dismissView() {
        
        if self.isAnimating { return }
        self.alertLabel.isHidden = true
        self.saveBtn.isHidden = true
        
        if let scrollView = self.containerView as? UIScrollView {
            
            self.isAnimating = true
            self.collectionView.isHidden = true
            // 假的图片
            let height: CGFloat = (self.bounds.width / self.currentImg!.size.width) * self.currentImg!.size.height
            
            let falseImageView = UIImageView()
            falseImageView.clipsToBounds = true
            falseImageView.contentMode = .scaleAspectFill
            
            falseImageView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: height)
            falseImageView.center = self.center
            
            falseImageView.image = self.currentImg
            self.addSubview(falseImageView)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.0)
                falseImageView.frame = self.originalRectWith(scrollView)
                
            }) { (isOK) in
                
                self.isAnimating = false
                self.removeFromSuperview()
            }
            
        } else {
            
            self.isAnimating = true
            UIView.animate(withDuration: 0.25, animations: {
                
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.0)
                self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                
            }) { (isOk) in
                
                self.isAnimating = false
                self.removeFromSuperview()
            }
        }
    }
    
    /// 获取原始位置
    private func originalRectWith(_ scrollView: UIScrollView) -> CGRect {
        
        var rect: CGRect!
        var frame:CGRect!
        if let col = scrollView as? UICollectionView {
            
            frame = col.cellForItem(at: IndexPath(row: self.currentIndex, section: 0))!.frame
            
        } else if let tab = scrollView as? UITableView {
            
            frame = tab.cellForRow(at: IndexPath(row: self.currentIndex, section: 0))!.frame
        }
        rect = self.containerView!.convert(frame, to: self)
        rect = self.convert(rect, to: kWindow)
        
        return rect
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height - 1.0)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoBrowerCell.self, forCellWithReuseIdentifier: "PhotoBrowerCell")
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = self.backgroundColor
        
        return collectionView
    }()

    /// 1/10
    private lazy var alertLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.white
        
        return label
    }()
    /// 保存到相册
    private lazy var saveBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
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
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        print("##### \(self)销毁了 #####")
    }
}

extension PhotoBrowserTool: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imgArr ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowerCell", for: indexPath) as! PhotoBrowerCell
        cell.scrollView.frame = CGRect(x: 0.0, y: 0.0, width:
            self.changeW, height: self.changeH)
        cell.clickCallBack = { [unowned self] in
            
            self.dismissView()
        }
        
        cell.imageView.image = UIImage(named: self.imgArr[indexPath.row]) ?? PhotoBrowserTool.placeholderImg
        cell.horizonImgV.image = cell.imageView.image
        cell.verticalImgV.image = cell.imageView.image
        
        if let isHorizonShow = self.isHorizonShow {
            
            cell.horizonImgV.isHidden = !isHorizonShow
            cell.verticalImgV.isHidden = isHorizonShow
            
            if let img = cell.imageView.image {
                
                let imgW = img.size.width
                let imgH = img.size.height
                let verticalH = kWidth * imgH / imgW
                let verticalW = kWidth
                let horizenW = kWidth * imgW / imgH
                let horizenH = kWidth
                
                let x1 = verticalW / horizenW
                let y1 = verticalH / horizenH
                
                if isHorizonShow {
                    
                    /// 横屏
                    cell.horizonImgV.transform = CGAffineTransform(scaleX: x1, y: y1)
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        cell.horizonImgV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
                    
                } else {
                    
                    /// 竖屏
                    cell.verticalImgV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        cell.verticalImgV.transform = CGAffineTransform(scaleX: x1, y: y1)
                        
                    }) { (isOk) in
                        
                        cell.verticalImgV.isHidden = true
                    }
                }
            }
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offSetY = scrollView.contentOffset.x
        let index = Int(offSetY / self.changeW)
        self.currentIndex = index

        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as! PhotoBrowerCell
        self.currentImg = cell.imageView.image
        
        self.alertLabel.text = "\(index + 1)/\(self.imgArr.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        (cell as? PhotoBrowerCell)?.resetImgV()
    }
}

extension PhotoBrowserTool {
    
    /// 屏幕翻转
    @objc func frameChangeNoteAction() {
        
        let orient = UIDevice.current.orientation
        UIView.animate(withDuration: 0.3, animations: {
            
            if orient == .portrait {
                
                self.collectionView.transform = CGAffineTransform.identity
                self.alertLabel.transform = CGAffineTransform.identity
                self.saveBtn.transform = CGAffineTransform.identity
                self.changeW = kWidth
                self.changeH = kHeight
                
                self.alertLabel.frame = CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0)
                self.saveBtn.frame = CGRect.init(x: (kWidth - 60.0) / 2.0, y: kHeight - 30.0 - 30.0, width: 60.0, height: 30.0)
                
                self.isHorizonShow = self.isChanged ? (false) : (nil)
                
            } else if orient == .landscapeLeft || orient == .landscapeRight {
                
                var angle: CGFloat = CGFloat.pi / 2.0
                orient == .landscapeLeft ? (angle = CGFloat.pi / 2.0) : (angle = -CGFloat.pi / 2.0)
                self.collectionView.transform = CGAffineTransform(rotationAngle: angle)
                self.alertLabel.transform = CGAffineTransform(rotationAngle: angle)
                self.saveBtn.transform = CGAffineTransform(rotationAngle: angle)
                
                self.changeW = kHeight
                self.changeH = kWidth
                
                if orient == .landscapeLeft {
                    
                    self.alertLabel.frame = CGRect.init(x: 0.0, y: 40.0, width: kWidth, height: 50.0)
                    self.saveBtn.frame = CGRect.init(x: (kWidth - 30.0) / 2.0, y: kHeight - 30.0 - 60.0, width: 30.0, height: 60.0)
                    
                } else {
                    
                    self.alertLabel.frame = CGRect.init(x: (kWidth - 50.0) / 2.0, y: kHeight - 30.0 - 60.0, width: 50.0, height: 50.0)
                    self.saveBtn.frame = CGRect.init(x: (kWidth - 30.0 ) / 2.0, y: 40.0, width: 30.0, height: 60.0)
                }
                self.isHorizonShow = true
                self.isChanged = true
            }
            
        }) { (isOk) in
            
            self.layout.itemSize = CGSize(width: self.changeW, height: self.changeH)
            self.collectionView.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint(x: self.changeW * CGFloat(self.currentIndex), y: 0.0), animated: false)
        }
    }
    
    /// 保存图片
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
}

class PhotoBrowerCell: UICollectionViewCell, UIScrollViewDelegate {
    
    /// 单击回调
    var clickCallBack:()->Void = {}
    var changeSize: CGSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.horizonImgV)
        self.scrollView.addSubview(self.verticalImgV)

        // 单击监听
        let scrollClick = UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
        scrollClick.numberOfTapsRequired = 1
        scrollClick.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(scrollClick)
        
        self.addTapTo(self.imageView)
        self.addTapTo(self.horizonImgV)
    }
    
    /// 添加点击事件
    func addTapTo(_ imgV: UIImageView) {
        
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
        imgV.addGestureRecognizer(tapSingle)
        imgV.addGestureRecognizer(tapDouble)
    }
    
    /// 重设大小
    func resetImgV() {
        
        self.scrollView.zoomScale = 1.0
        self.imageView.center = self.scrollView.center
        self.horizonImgV.center = self.scrollView.center
    }
    
    /// 图片单击事件响应
    @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
        
        self.clickCallBack()
    }
    /// 图片双击事件响应
    @objc func tapDoubleDid(_ ges:UITapGestureRecognizer){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
            if let weakSelf = weakSelf {
                
                // 如果当前不缩放，则放大到3倍。否则就还原
                if weakSelf.scrollView.zoomScale == 1.0 {
                    
                    // 以点击的位置为中心，放大3倍
                    let pointInView = ges.location(in: self.imageView)
                    let newZoomScale: CGFloat = 3
                    let scrollViewSize = weakSelf.scrollView.bounds.size
                    let w = scrollViewSize.width / newZoomScale
                    let h = scrollViewSize.height / newZoomScale
                    let x = pointInView.x - ( w / 2.0)
                    let y = pointInView.y - ( h / 2.0)
                    let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
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

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        return scrollView
    }()
    
    /// 展示使用
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: self.contentView.bounds)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    /// 竖屏缩小使用
    lazy var horizonImgV: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: kHeight, height: kWidth))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true

        return imageView
    }()
    /// 横屏缩小使用
    lazy var verticalImgV: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: kHeight, height: kWidth))
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.contentView.center
        imageView.isHidden = true
        
        return imageView
    }()
    
    //MARK: -Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.horizonImgV.isHidden ? (self.imageView) : (self.horizonImgV)
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            (scrollView.contentSize.width / 2) : (scrollView.center.x)
        let centerY = scrollView.contentSize.height > scrollView.frame.size.height ? (scrollView.contentSize.height / 2) : (scrollView.center.y)
        
        (self.horizonImgV.isHidden ? (self.imageView) : (self.horizonImgV)).center = CGPoint(x: centerX, y: centerY)
    }
    
    deinit {
        print("##### \(self)销毁了 #####")
    }
}
