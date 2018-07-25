//
//  ADScrollViewTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/24.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class VerticalADView: UIView {
    
    var clickBlock: ((Int)->Void)?
    var currentIndex: Int = 0 {
        
        willSet {
            
            self.pageControl.currentPage = newValue
        }
    }
    var imgUrlArr: [String] = [] {
        
        didSet {
            
            self.scrolView.addSubview(self.firstImgV)
            self.scrolView.addSubview(self.secondImgV)
            self.scrolView.addSubview(self.thirdImgV)
            self.startTimer()
            self.addSubview(self.pageControl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.scrolView)
        self.scrolView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: true)
    }
    /// 启动定时器
    @objc func startTimer() {
        
        self.stopTimer()
        self.k_startTimer(timerIdentifier: "VerticalADView", timeInterval: 2.0, repeats: true) { [unowned self] (timer) in
            
            DispatchQueue.main.async {
                
                self.scrolView.setContentOffset(CGPoint.init(x: 0.0, y: self.bounds.height * 2.0), animated: true)
            }
        }
    }
    /// 销毁定时器
    func stopTimer() {
        
        self.k_stopTimer(timerIdentifier: "VerticalADView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrolView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.contentSize = CGSize(width: 0.0, height: self.bounds.height * 3.0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    lazy var firstImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        if self.imgUrlArr.isEmpty {
            
            imgV.image = nil
            
        } else {
            
            imgV.image = UIImage.init(named: self.imgUrlArr.last!)
        }
        imgV.k_addTarget({ (tap) in
            
            self.clickBlock?(self.currentIndex)
        })
        
        return imgV
    }()
    lazy var secondImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        if self.imgUrlArr.isEmpty {
            
            imgV.image = nil
            
        } else {
            
            imgV.image = UIImage.init(named: self.imgUrlArr.first!)
        }
        imgV.k_addTarget({ (tap) in
            
            self.clickBlock?(self.currentIndex)
        })
        
        return imgV
    }()
    lazy var thirdImgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: self.bounds.height * 2.0, width: self.bounds.width, height: self.bounds.height))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        if self.imgUrlArr.count > 1 {
            
            imgV.image = UIImage.init(named: self.imgUrlArr[1])
            
        } else if self.imgUrlArr.isEmpty {
            
            imgV.image = nil
            
        } else {
            
            imgV.image = UIImage.init(named: self.imgUrlArr.first!)
        }
        imgV.k_addTarget({ (tap) in
            
            self.clickBlock?(self.currentIndex)
        })
        
        return imgV
    }()
    lazy var pageControl: UIPageControl = { [unowned self] in
        let wh: CGFloat = 20.0
        let width: CGFloat = wh * CGFloat(self.imgUrlArr.count)
        let pageControl = UIPageControl(frame: CGRect(x: self.bounds.width - width + 10.0, y: self.bounds.height - wh - 40.0, width: width, height: wh))
        pageControl.numberOfPages = self.imgUrlArr.count
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        
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

        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY <= 0.0 {
            
            self.currentIndex = self.currentIndex == 0 ? (self.imgUrlArr.count - 1) : (self.currentIndex - 1)
            
            self.thirdImgV.image = self.secondImgV.image
            self.secondImgV.image = self.firstImgV.image
            self.firstImgV.image = UIImage.init(named: self.dealArr[0])
           
            scrollView.setContentOffset(CGPoint(x: 0.0, y: self.bounds.height), animated: false)
            
        } else if offsetY >= self.bounds.height * 2.0 {
            
            self.currentIndex = self.currentIndex == self.imgUrlArr.count - 1 ? (0) : (self.currentIndex + 1)
            self.firstImgV.image = self.secondImgV.image
            self.secondImgV.image = self.thirdImgV.image
            self.thirdImgV.image = UIImage.init(named: self.dealArr[2])
           
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
