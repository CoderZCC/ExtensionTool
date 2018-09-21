//
//  CalendarView.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/25.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CalendarView: UIView {

    /// 展示日历
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - block: 点击回调
    /// - Returns: 对象
    class func showCalendarWith(frame: CGRect, block:((String)->Void)?) -> CalendarView {
        
        let tool = CalendarView.loadXibView()
        tool.frame = frame
        tool.block = block
        
        return tool
    }
    
    /// 设置状态
    ///
    /// - Parameters:
    ///   - date: 日期
    func setStateSelected(with: [Date]) {
        
        self.selectedDays = []
        for date in with {
            let compent = date.k_YMDHMS()
            let month = String.init(format: "%.2ld", compent.month!)
            let day = String.init(format: "%.2ld", compent.day!)

            let str = "\(compent.year!) \(month)-\(day)"
            self.selectedDays!.append(str)
        }
    }
    
    /// 标题文字
    @IBOutlet private weak var timeLabel: UILabel!
    /// 集合视图
    @IBOutlet private weak var colllectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    /// 月天数 -防止多次计算
    private var monthsCount: Int?
    /// 空格数 -防止多次计算
    private var spaceCount: Int?
    /// 点击回调
    private var block:((String)->Void)?
    /// 选中的日期数组
    private var selectedDays: [String]?
    /// 当前时间
    private var currentYM: (year: Int, month: Int)! {
        
        willSet {
            
            self.monthsCount = nil
            self.spaceCount = nil
            self.timeLabel.text = "\(newValue.year)年\(newValue.month)月"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layout.minimumLineSpacing = 0.0
        self.layout.minimumInteritemSpacing = 0.0
        self.colllectionView.contentInset = UIEdgeInsets.init(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        self.layout.itemSize = CGSize(width: (self.bounds.width - 10.0) / 7.0, height: 40.0)

        self.colllectionView.delegate = self
        self.colllectionView.dataSource = self
        self.colllectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: "CalendarViewCell")
        
        let compent = Date().k_YMDHMS()
        self.currentYM = (compent.year ?? 2018, compent.month ?? 1)
    }
    
    private class func loadXibView() -> CalendarView {
        let tool = Bundle.main.loadNibNamed("CalendarView", owner: nil, options: nil)?.first as! CalendarView
        
        return tool
    }
    
    /// 上一个月事件
    @IBAction private func lastMonthAction() {
        
        var year = self.currentYM.year
        var month = self.currentYM.month
        if month == 1 {
            
            month = 12
            year -= 1
            
        } else {
            
            month -= 1
        }
        self.currentYM = (year, month)
        self.colllectionView.reloadData()
    }
    
    /// 下一个月事件
    @IBAction private func nextMonthAction() {
        
        var year = self.currentYM.year
        var month = self.currentYM.month
        if month == 12 {
            
            month = 1
            year += 1
            
        } else {
            
            month += 1
        }
        self.currentYM = (year, month)
        self.colllectionView.reloadData()
    }
    
    /// 当前月有多少天
    private func daysInMonth() -> Int {
        
        if let count = self.monthsCount { return count }
        
        let year = self.currentYM.year
        let month = self.currentYM.month
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.year = year
        startComps.month = month
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.year = (month == 12 ? (year + 1) : (year))
        endComps.month = (month == 12 ? (1) : (month + 1))
        
        let calendar = Calendar.current
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
        
        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        self.monthsCount = diff.day ?? 0
        
        return self.monthsCount!
    }
    
    /// 插入空字符串
    private func nilStrInFront() -> Int {
        
        if let count = self.spaceCount { return count }
        
        let timeStr = "\(self.currentYM.year) \(self.currentYM.month)-01"
        let timeDate = timeStr.k_toDate(formatter: "yyyy MM-dd")
      
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let weekday = calendar.dateComponents([.weekday], from: timeDate).weekday ?? 1
        self.spaceCount = weekday - 1
        
        return self.spaceCount!
    }
    
    deinit {
        print("###\(self)销毁了###\n")
    }
    
}

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarViewCell
        if !cell.isClickEnabled { return }
        cell.isTextLSelected = !cell.isTextLSelected
        self.block?(cell.selectedText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.daysInMonth() + self.nilStrInFront()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarViewCell", for: indexPath) as! CalendarViewCell
        cell.setTextL(currentYM: self.currentYM, with: indexPath.row < self.nilStrInFront() ? (nil): ("\(indexPath.row - self.nilStrInFront() + 1)"), selectedDate: self.selectedDays)
        
        return cell
    }
}

class CalendarViewCell: UICollectionViewCell {
    
    /// 完整的时间
    var selectedText: String!
    /// 是否可以点击
    var isClickEnabled: Bool {
        
        return !self.textL.isHidden && self.textL.textColor != UIColor.black
    }
    /// 是否被选中
    var isTextLSelected: Bool = false {
        
        willSet {
            
            self.textL.backgroundColor = newValue ? (UIColor.red) : (UIColor.lightGray)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textL)
    }
    
    /// 设置label文字
    ///
    /// - Parameters:
    ///   - currentYM: 当前年月
    ///   - with: 文字
    func setTextL(currentYM: (year: Int, month: Int), with: String?, selectedDate: [String]?) {
        
        self.textL.isHidden = (with == nil)
        if let with = with {
            
            self.textL.text = with

            let month = String.init(format: "%.2ld", currentYM.month)
            let day = String.init(format: "%.2ld", with.k_toInt())
            
            let timeStr = "\(currentYM.year) \(month)-\(day)"
            self.selectedText = timeStr
            if (selectedDate ?? []).contains(self.selectedText) {
                
                // 设置选中状态
                self.isTextLSelected = true
                self.textL.textColor = UIColor.white
                
            } else {
                
                self.isTextLSelected = false
                let timeDate = timeStr.k_toDate(formatter: "yyyy MM-dd")
                let nowDate = Date().k_toDateStr("yyyy MM-dd").k_toDate(formatter: "yyyy MM-dd")
                
                if timeDate.k_compareToDate(nowDate) == 2 {
                    
                    self.textL.backgroundColor = UIColor.white
                    self.textL.textColor = UIColor.darkText
                    
                } else {
                    
                    self.textL.backgroundColor = UIColor.lightGray
                    self.textL.textColor = UIColor.white
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textL: UILabel = {
        let labelWH: CGFloat = self.bounds.height - 10.0
        let label = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: labelWH, height: labelWH))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
        label.center = self.contentView.center
        label.k_setCornerRadius(label.bounds.height / 2.0)
        
        return label
    }()
}

