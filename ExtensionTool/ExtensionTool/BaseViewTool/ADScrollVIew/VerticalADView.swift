//
//  ADScrollViewTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/24.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

protocol VerticalADViewProtocol: NSObjectProtocol {
    
    func clickADCallBack(index: Int)
}

class VerticalADView: UIView {
    
    //MARK: -调用部分
    /// 代理
    var adDelegate: VerticalADViewProtocol?
    /// 当前下标
    var currentIndex: Int = 0 {
        
        willSet {
            
            self.pageControl.currentPage = newValue
        }
    }
    /// 数据源,给这个赋值
    var imgUrlArr: [String] = [] {
        
        didSet {
            
            self.updateSubView()
        }
    }
    
    /// 初始化轮播
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - imgUrlArr: 图片数组
    ///   - block: 回调
    init(frame: CGRect, imgUrlArr: [String]? = nil, block: @escaping ((Int)->Void)) {
        super.init(frame: frame)
        
        if let arr = imgUrlArr, !arr.isEmpty {
            
            self.imgUrlArr = arr
        }
        self.clickBlock = block
        
        self.addSubview(self.scrolView)
        self.scrolView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: true)
    }
    
    /// 启动定时器
    @objc func startTimer() {
        
        self.stopTimer()
        self.k_startTimer(timerIdentifier: "VerticalADView", timeInterval: 2.0, repeats: true) { [unowned self] (timer) in
            
            DispatchQueue.main.async {
                
                if let _ = timer {
                    
                    self.scrolView.setContentOffset(CGPoint.init(x: 0.0, y: self.bounds.height * 2.0), animated: true)
                }
            }
        }
    }
    /// 销毁定时器
    func stopTimer() {
        
        self.k_stopTimer(timerIdentifier: "VerticalADView")
    }
    
    //MARK: -实现部分
    /// 点击的回调
    private var clickBlock: ((Int)->Void)?
    /// pageControl的宽高
    private let pageWH: CGFloat = 20.0
    /// 是否刚启动
    private var isFirstRun: Bool = true
    /// 设置图片
    ///
    /// - Parameters:
    ///   - imgV: 图片View
    ///   - with: 字符串
    private func setImage(to imgV: UIImageView, with: String) {
        
        imgV.image = nil
        if with.hasPrefix("http") {
            
            //imgV.sd_setImage(with: URL.init(string: with))
            
        } else {
            
            imgV.image = UIImage.init(named: with)
        }
    }
    
    /// 更新页面控件
    private func updateSubView() {
        
        // 下标归0
        self.currentIndex = 0
        // 更新图片
        if self.imgUrlArr.isEmpty {
            
            self.firstImgV.image = nil
            self.secondImgV.image = nil
            self.thirdImgV.image = nil
            
        } else {
            
            self.setImage(to: self.firstImgV, with: self.imgUrlArr.last!)
            self.setImage(to: self.secondImgV, with: self.imgUrlArr.first!)
            self.setImage(to: self.thirdImgV, with: self.imgUrlArr.count > 1 ? (self.imgUrlArr[1]) : (self.imgUrlArr.first)!)
        }
        
        // 更新pageControl
        let width: CGFloat = self.pageWH * CGFloat(self.imgUrlArr.count)
        self.pageControl.frame = CGRect(x: self.bounds.width - width - 15.0, y: self.bounds.height - self.pageWH - 10.0, width: width, height: self.pageWH)
        self.pageControl.numberOfPages = self.imgUrlArr.count
        pageControl.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)

        // 重启定时器
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startTimer), object: nil)
        self.perform(#selector(startTimer), with: nil, afterDelay: 2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrolView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.contentSize = CGSize(width: 0.0, height: self.bounds.height * 3.0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private lazy var firstImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        
        self.scrolView.addSubview(imgV)
        return imgV
    }()
    private lazy var secondImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.k_addTarget({ (tap) in
            
            self.clickBlock?(self.currentIndex)
            self.adDelegate?.clickADCallBack(index: self.currentIndex)
        })
        self.scrolView.addSubview(imgV)

        return imgV
    }()
    private lazy var thirdImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: self.bounds.height * 2.0, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
       
        self.scrolView.addSubview(imgV)
        return imgV
    }()
    private lazy var pageControl: UIPageControl = { [unowned self] in
        let width: CGFloat = self.pageWH * CGFloat(self.imgUrlArr.count)
        let pageControl = UIPageControl(frame: CGRect(x: self.bounds.width - width + 10.0, y: self.bounds.height - self.pageWH - 40.0, width: width, height: self.pageWH))
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        self.addSubview(pageControl)
        
        return pageControl
    }()
    
    /// 数据源
    private var dealArr: [String] {
        
        var arr: [String] = []
        var firstIndex: Int = 0
        var secondIndex: Int = 0
        var thirdIndex: Int = 0
        switch self.imgUrlArr.count {
            
        case 0:
            break
            
        case 1:
            
            for _ in 0..<3 { arr.append(self.imgUrlArr[0]) }
            
        default :
            
            firstIndex = (self.currentIndex - 1) < 0 ? self.imgUrlArr.count - 1 : self.currentIndex - 1
            secondIndex = self.currentIndex
            thirdIndex = (self.currentIndex + 1) > self.imgUrlArr.count - 1 ? 0 : self.currentIndex + 1
            
            arr = [self.imgUrlArr[firstIndex], self.imgUrlArr[secondIndex], self.imgUrlArr[thirdIndex] ]
        }
        return arr
    }
}

extension VerticalADView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.imgUrlArr.isEmpty { return }
        if self.isFirstRun {
            
            scrollView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: false)
            DispatchQueue.k_asyncAfterOnMain(dealyTime: 1.0, callBack: {
                
                self.isFirstRun = false
                self.scrollViewDidScroll(scrollView)
            })
            return
        }
        
        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY <= 0.0 {
            
            self.currentIndex = self.currentIndex == 0 ? (self.imgUrlArr.count - 1) : (self.currentIndex - 1)
            
            self.thirdImgV.image = self.secondImgV.image
            self.secondImgV.image = self.firstImgV.image
            self.setImage(to: self.firstImgV, with: self.dealArr[0])

            scrollView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: false)
            
        } else if offsetY >= self.bounds.height * 2.0 {
            
            self.currentIndex = self.currentIndex == self.imgUrlArr.count - 1 ? (0) : (self.currentIndex + 1)
            self.firstImgV.image = self.secondImgV.image
            self.secondImgV.image = self.thirdImgV.image
            self.setImage(to: self.thirdImgV, with: self.dealArr[2])

            scrollView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: false)
        }
    }
    // 开始滚动时,取消之前的延迟操作
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.stopTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self,  selector: #selector(startTimer), object: nil)
    }
    // 结束滚动时,重启延迟操作
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.perform(#selector(startTimer), with: nil, afterDelay: 2.0)
    }
}
