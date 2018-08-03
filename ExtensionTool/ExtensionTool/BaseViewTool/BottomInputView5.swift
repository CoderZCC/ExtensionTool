//
//  BottomInputView5.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/3.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BottomInputView5: UIView {
    
    //MARK: -调用部分
    /// 初始化工具
    ///
    /// - Parameters:
    ///   - inputView: UITextView
    ///   - block: 回调
    class func initWith(_ inputView: UITextView, block: ((UIImage) ->Void)?) -> BottomInputView5 {
        let toolHeight: CGFloat = 49.0 + kBottomSpace
        let tool = BottomInputView5.init(frame: CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: toolHeight))
        tool.k_height += tool.extraHeight
        tool.originalFrame = CGRect(x: 0.0, y: kHeight - toolHeight, width: kWidth, height: 49.0)

        tool.registerNote()
        tool.initSubViews()
        tool.textView = inputView
        tool.imgCallBack = block
        
        return tool
    }
    
    //MARK: -实现部分
    /// 额外的高度 键盘收起时.展示emoijView
    private var extraHeight: CGFloat = 200.0 + kBottomSpace
    /// 输入框
    private var textView: UITextView!
    /// 原始位置
    private var originalFrame: CGRect!
    /// 图片回调
    private var imgCallBack: ((UIImage)->Void)?
    /// 左侧约束
    private let leftMargin: CGFloat = 15.0
    /// 按钮之间的约束
    private let cellMargin: CGFloat = 10.0
    /// 单元格大小
    private let cellWH: CGFloat = 49.0
    /// 个数
    private let dataList: [UIImage] = [#imageLiteral(resourceName: "emoij"), #imageLiteral(resourceName: "photo"), #imageLiteral(resourceName: "camera")]
    /// 是否展示多余的部分
    private var isShowExtra: Bool = false
    
    /// 通知
    private var note1: NSObjectProtocol!
    private var note2: NSObjectProtocol!
    
    /// 控件
    private func initSubViews() {

        self.addSubview(self.collectionView)
        self.addSubview(self.emoijView)
    }
    
    /// 注册通知
    private func registerNote() {
        
        self.note1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            var height: CGFloat = 271.0
            if let dic = note.userInfo {
                
                let value = dic[UIKeyboardFrameEndUserInfoKey] as! NSValue
                height = value.cgRectValue.size.height
            }
            self.setEmoijEnabled(isEnabled: true)
            self.isShowExtra = false
            self.emoijView.alpha = 0.0
            self.transform = CGAffineTransform.init(translationX: 0.0, y: -height)
        }
        
        self.note2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (note) in
            
            if !self.isShowExtra {
                
                self.transform = CGAffineTransform.identity
            }
        }
    }
    /// 销毁通知
    private func destroyNote() {
        
        NotificationCenter.default.removeObserver(self.note1)
        NotificationCenter.default.removeObserver(self.note2)
    }
    
    /// 收起
    private func hiddenExtraView() {
        
        self.textView.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            
            self.emoijView.alpha = 0.0
            self.transform = CGAffineTransform.identity
        })
    }
    /// 展开
    private func showExtraView() {
        
        self.isShowExtra = true
        self.textView.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            
            self.transform = CGAffineTransform(translationX: 0.0, y: -self.extraHeight + kBottomSpace)
        })
        
//        // 加入蒙版
//        if let superview = self.superview {
//
//            superview.insertSubview(self.insertView, belowSubview: self)
//        }
    }
    
    /// 设置表情按钮图片
    func setEmoijEnabled(isEnabled: Bool) {
        
        let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0 ))
        let imgV = cell?.viewWithTag(101) as! UIImageView
        imgV.image = isEnabled ? (#imageLiteral(resourceName: "emoij")) : (#imageLiteral(resourceName: "keyBorad"))
    }
    
    // MARK: -Lazy
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = self.cellMargin
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: self.cellWH, height: self.cellWH)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.originalFrame.width, height: self.originalFrame.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.k_registerCell(cls: UICollectionViewCell.self)
        collectionView.backgroundColor = self.backgroundColor
        collectionView.contentInset = UIEdgeInsetsMake(0.0, self.leftMargin, 0.0, 0.0)
        
        return collectionView
    }()
    
    private lazy var emoijView: EmoijView = {
        let view = EmoijView.init(frame: CGRect(x: 0.0, y: self.collectionView.frame.maxY, width: self.bounds.width, height: self.extraHeight))
        view.alpha = 0.0
        view.clickCallBack = { [unowned self] str in
            
            if str.contains("delete") {
                
                if let text = self.textView.text, !text.isEmpty {
                    
                    self.textView.text.removeLast()
                }
                
            } else {
                
                self.textView.text.append(str)
            }
        }
        
        return view
    }()
    
    private lazy var insertView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.k_addTarget({ [unowned self] (tap) in
            
            DispatchQueue.main.async {[unowned self] in
                
                self.isShowExtra = false
                self.textView.resignFirstResponder()
                self.setEmoijEnabled(isEnabled: true)
                
                UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                    
                    self.emoijView.alpha = 0.0
                    self.transform = CGAffineTransform.identity
                })
            }
        })
        
        return view
    }()
    
    deinit {
        
        self.destroyNote()
        print("###\(self)销毁了###\n")
    }
}

extension BottomInputView5: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        switch indexPath.row {
        case 0:
            
            let cell = collectionView.cellForItem(at: indexPath)
            if (cell?.viewWithTag(101) as! UIImageView).image == #imageLiteral(resourceName: "emoij") {
                
                // emoij
                self.showExtraView()
                self.setEmoijEnabled(isEnabled: false)
                self.emoijView.alpha = 1.0
                
            } else {
                
                self.textView.becomeFirstResponder()
                self.setEmoijEnabled(isEnabled: true)
                self.emoijView.alpha = 0.0
            }
            
        case 1:
            
            // 进入相册
            self.hiddenExtraView()
            CameraTool.takeFromLibrary(block: self.imgCallBack)
            
        case 2:
            
            // 相机
            self.hiddenExtraView()
            CameraTool.takeFromCamera(block: self.imgCallBack)
            
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.k_dequeueReusableCell(cls: UICollectionViewCell.self, indexPath: indexPath)
        
        var imgV = cell.contentView.viewWithTag(101) as? UIImageView
        if imgV == nil {
            imgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
            imgV?.contentMode = .scaleAspectFit
            imgV?.center = cell.contentView.center
            imgV?.tag = 101
            cell.contentView.addSubview(imgV!)
        }
        imgV?.image = self.dataList[indexPath.row]

        return cell
    }
}

