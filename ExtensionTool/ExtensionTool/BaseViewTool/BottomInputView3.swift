//
//  BottomInputView3.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/30.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 输入框(可换行) + 按钮 + 底部View
class BottomInputView3: UIView, UITextViewDelegate {

    //MARK: -调用部分
    /// 占位文字
    var placeHolder: String? {
        willSet {
            self.textView.k_placeholder = newValue
        }
    }
    /// 点击文字回调
    var textCallBack: ((String)->Void)?
    
    class func initInputView() -> BottomInputView3 {
        
        let tool = BottomInputView3.init(frame: CGRect(x: 0.0, y: kHeight - 49.0 - kBottomSpace, width: kWidth, height: 44.0 + kBottomSpace))
        tool.k_height += tool.extraHeight
        tool.originalFrame = CGRect(x: 0.0, y: kHeight - 44.0 - kBottomSpace, width: kWidth, height: 49.0)
        tool.initSubViews()
        tool.registerNote()
        
        return tool
    }
    
    /// 注册通知
    func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            self.keyboradHeight = height
            self.transform = CGAffineTransform(translationX: 0.0, y: -self.keyboradHeight + kBottomSpace)
            
            self.emoijView.transform =  CGAffineTransform(translationX: 0.0, y: kHeight)

            self.isEditting = true
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            if self.isClickEmoij { return }
            self.transform = CGAffineTransform.identity
            self.isEditting = false
        }
        
        self.note3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            let textView = note.object as! UITextView
            let text: String = textView.text ?? ""
            
            let textHeight = self.getInputTextHeight(text: text)

            if self.lastHeight != textHeight {

                // 输入框
                var tVFrame = textView.frame
                tVFrame.size.height = textHeight - (self.originalFrame.height - self.tFHeight)
                tVFrame.size.height = max(self.originalTVFrame.height, tVFrame.size.height)
                
                // 父视图
                var newFrame = self.frame
                newFrame.size.height = max(self.originalFrame.height, textHeight) + self.keyboradHeight + self.extraHeight
                newFrame.origin.y = kHeight - max(self.originalFrame.height, textHeight) - self.keyboradHeight
                
                // 按钮
                var btnFrame = self.rightBtn.frame
                btnFrame.origin.y = (newFrame.size.height - self.keyboradHeight - self.btnHeight) - (self.originalFrame.height - self.btnHeight) / 2.0 - self.extraHeight
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.frame = newFrame
                    textView.frame = tVFrame
                    self.rightBtn.frame = btnFrame
                })
                self.lastHeight = textHeight
                // 偏移,防止文字展示不全
                textView.setContentOffset(CGPoint(x: 0.0, y: self.lastHeight == self.originalTVFrame.height ? (0.0): (4.0)), animated: true)
            }
        }
    }
    /// 销毁通知
    func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
        NotificationCenter.default.removeObserver(self.note3)
    }
    
    //MARK: -实现部分
    /// 输入框高度
    private let tFHeight: CGFloat = 35.0
    /// 输入框左侧间隔
    private let tFLeftMargin: CGFloat = 10.0
    /// 输入框右侧间隔
    private let tFRightMargin: CGFloat = 15.0
    /// 按钮宽度
    private let btnWidth: CGFloat = 35.0
    /// 按钮高度
    private let btnHeight: CGFloat = 35.0
    /// 按钮右侧间隔
    private let btnRightMargin: CGFloat = 15.0
    /// 原始位置
    private var originalFrame: CGRect!
    /// 输入框原始位置
    private var originalTVFrame: CGRect!
    /// 标记换行
    private var lastHeight: CGFloat!
    /// 键盘高度
    private var keyboradHeight: CGFloat = 271.0
    /// 键盘是否弹出
    private var isEditting: Bool = false
    /// 额外的高度 键盘收起时.展示emoijView
    private var extraHeight: CGFloat = 180.0 + kBottomSpace
    /// 是否点击了emoij
    private var isClickEmoij: Bool = false
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    private var note3: NSObjectProtocol!
    
    /// 添加控件
    private func initSubViews() {
        
        self.addSubview(self.rightBtn)
        self.addSubview(self.textView)
        self.addSubview(self.emoijView)
    }
    
    /// 计算文字高度
    private func getInputTextHeight(text: String) -> CGFloat {
        
        if text.isEmpty {
            
            return self.originalTVFrame.height
        }
        let str = NSString.init(string: text)
        let rect = str.boundingRect(with: CGSize.init(width: self.textView.frame.width - 10.0, height: 999.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : self.textView.font!], context: nil)
        return max(rect.size.height + 13.0, self.originalTVFrame.height)
    }
    
    //MARK: -Lazy
    private lazy var textView: UITextView = {
        self.originalTVFrame = CGRect(x: self.tFLeftMargin, y: (self.originalFrame.height - self.tFHeight) / 2.0, width: kWidth - self.tFLeftMargin - self.tFRightMargin - self.btnWidth - self.btnRightMargin, height: self.tFHeight)
        self.lastHeight = self.originalTVFrame.height
        let textView = UITextView.init(frame: self.originalTVFrame)
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.layer.cornerRadius = 5.0
        textView.clipsToBounds = true
        textView.returnKeyType = .send
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var rightBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "emoij"), for: .normal)
        btn.frame = CGRect(x: self.originalFrame.width - self.btnWidth - self.btnRightMargin, y: (self.originalFrame.height - self.btnHeight) / 2.0, width: self.btnWidth, height: self.btnHeight)
        btn.k_setCornerRadius(5.0)
        
        btn.k_addTarget { [unowned self] in
            
            DispatchQueue.main.async {[unowned self] in
                
                self.isClickEmoij = true
                if self.isEditting {
                    
                    self.textView.resignFirstResponder()
                }
                UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                    
                    self.emoijView.transform = CGAffineTransform(translationX: 0.0, y: self.textView.frame.maxY + 8.0)
                    self.transform = CGAffineTransform(translationX: 0.0, y: -self.extraHeight + kBottomSpace)
                })
            }
        }
        
        return btn
    }()
    
    lazy var emoijView: EmoijView = {
        let view = EmoijView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.originalFrame.width, height: self.extraHeight))
        view.transform = CGAffineTransform(translationX: 0.0, y: kHeight)
        
        return view
    }()
    
    lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async {[unowned self] in
                
                self.isClickEmoij = false
                self.textView.resignFirstResponder()
                
                UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                    
                    self.emoijView.transform =  CGAffineTransform(translationX: 0.0, y: kHeight)
                    self.transform = CGAffineTransform.identity
                    self.isEditting = false
                })
            }
        })
        
        return view
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let newSuperview = newSuperview {
            
            // 添加蒙版
            newSuperview.insertSubview(self.insertView, belowSubview: self)
            
        } else {
            
            self.insertView.removeFromSuperview()
        }
    }
    
    deinit {
        
        self.destroyNote()
        print("###\(self)销毁了###\n")
    }
    
    //MARK: -UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && !textView.text.isEmpty {
            
            textView.resignFirstResponder()
            textCallBack?(textView.text!)
            
            textView.text = ""
            self.textView.k_placeholder = self.placeHolder
            
            return false
        }
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.textView.setContentOffset(CGPoint(x: 0.0, y: 4.0), animated: true)
    }
}

class EmoijView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Lazy
    lazy var dataList: [String] = {
        let path = Bundle.main.path(forResource: "EmotionPlist", ofType: "plist")
        var arr: [String] = []
        for str in NSArray.init(contentsOfFile: path!)! {
            arr.append(str as! String)
        }
        
        return arr
    }()
    
    /// pageControl的高度
    lazy var pClHeight: CGFloat = {
        
        return kIsIphoneX ? (40.0) : (20.0)
    }()
    /// page的个数
    lazy var pageNum: Int = {
        
        return self.dataList.count / (3 * 9)
    }()
    /// pageControl
    lazy var pageControl: UIPageControl = { [unowned self] in
        let width: CGFloat = CGFloat(self.dataList.count) * 30.0
        let pageControl = UIPageControl.init(frame: CGRect(x: (self.bounds.width - width) / 2.0, y: self.bounds.height - kBottomSpace - 30.0 - 10.0, width: width, height: 30.0))
        if kIsIphoneX {
            pageControl.frame = CGRect(x: (self.bounds.width - width) / 2.0, y: self.bounds.height - kBottomSpace - 25.0, width: width, height: 30.0)
        }
        pageControl.numberOfPages = self.pageNum
        
        return pageControl
    }()
    /// collectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 8.0, y: 0.0, width: self.bounds.width - 16.0, height: self.bounds.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmoijViewCell.self, forCellWithReuseIdentifier: "EmoijViewCell")
        collectionView.contentInset = UIEdgeInsetsMake(8.0, 0.0, 20.0 + self.pClHeight, 0.0)
        collectionView.backgroundColor = self.backgroundColor
        collectionView.isPagingEnabled = true
        
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        let cellHeight: CGFloat = (collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom - layout.minimumInteritemSpacing * 2.0) / 3.0
        let cellWidth: CGFloat = (collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - layout.minimumLineSpacing * 8.0) / 9.0

        layout.itemSize = CGSize.init(width: cellWidth, height: cellHeight)
        
        return collectionView
    }()
}

extension EmoijView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoijViewCell", for: indexPath) as! EmoijViewCell
        cell.textL.text = self.dataList[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / self.bounds.width)
        self.pageControl.currentPage = page
    }
    
}

class EmoijViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.textL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textL: UILabel = {
        let label = UILabel.init(frame: self.contentView.bounds)
        label.textAlignment = .center
        
        return label
    }()
    
}

