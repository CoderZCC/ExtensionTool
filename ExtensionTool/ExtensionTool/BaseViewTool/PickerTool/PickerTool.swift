//
//  DatePickerTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/9/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class PickerTool: NSObject {
    
    /// 展示时间控件
    ///
    /// - Parameters:
    ///   - showModel: 展示类型 countDownTimer 时分(计时器) // time 时分(PM/AM) // date 年月日 // dateAndTime 月日时分
    ///   - currentTime: 默认时间
    ///   - minimumDate: 最小时间
    ///   - maximumDate: 最大时间
    ///   - block: 选中回调
    class func showDatePicker(with showModel: UIDatePickerMode, currentTime: Date? = Date(), minimumDate: Date? = nil, maximumDate: Date? = Date(), block: ((String)->Void)?) {
        
        DatePickerTool.show(with: showModel, currentTime: currentTime, minimumDate: minimumDate, maximumDate: maximumDate, block: block)
    }
    
    /// 展示地址控件
    ///
    /// - Parameters:
    ///   - type: 类型  .provinceCityArea 省市区 // .provinceCity 省市
    ///   - block: 选中回调
    class func showAddressPicker(with type: AddressType = .provinceCityArea, block: ((String)->Void)?) {
        
        AddressPickerTool.show(with: type, block: block)
    }
}

class DatePickerTool: UIView {

    /// 返回的字符串类型
    static let callbackStyle: String = "yyyy MM-dd HH:mm"
    
    /// 展示时间控件
    ///
    /// - Parameters:
    ///   - showModel: 展示类型
    ///   - currentTime: 显示的时间
    ///   - minimumDate: 最小时间
    ///   - maximumDate: 最大时间
    ///   - callback: 选中回调
    class func show(with showModel: UIDatePickerMode, currentTime: Date? = Date(), minimumDate: Date? = nil, maximumDate: Date? = Date(), block: ((String)->Void)?) {
        
        let picker = DatePickerTool(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        if picker.isAnimating { return }
        picker.isAnimating = true
        kWindow.addSubview(picker)
        
        if let currentTime = currentTime {
            
            picker.datePickerView.setDate(currentTime, animated: true)
        }
        picker.datePickerView.datePickerMode = showModel
        picker.datePickerView.minimumDate = minimumDate
        picker.datePickerView.maximumDate = maximumDate
        picker.callback = block
        
        picker.showView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            
            picker.alpha = 1.0
            picker.showView.transform = CGAffineTransform.identity
            
        }) { (isOk) in
            
            picker.isAnimating = false
        }
    }
    
    private var totalHeight: CGFloat {
        
        return kIsIphoneX ? (240.0 + 34.0) : (240.0)
    }
    private let toolHeight: CGFloat = 40.0
    private let pickerHeight: CGFloat = 200.0
    /// 是否在执行动画
    private var isAnimating: Bool = false
    /// 回调
    private var callback: ((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(self.showView)
        self.showView.addSubview(self.topView)
        self.topView.addSubview(self.cancleBtn)
        self.topView.addSubview(self.sureBtn)
        self.showView.addSubview(self.datePickerView)
    }
    
    /// 取消事件
    @objc private func cancleAction() {
        
        if self.isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform.init(translationX: 0.0, y: UIScreen.main.bounds.height)
            
        }) { (isOK) in
            
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    /// 确定事件
    @objc private func sureAction() {
        
        self.cancleAction()
        
        let fat = DateFormatter()
        fat.timeZone = TimeZone.current
        fat.dateFormat = DatePickerTool.callbackStyle
        let str = fat.string(from: self.datePickerView.date)
        
        self.callback?(str)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
    private lazy var showView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.bounds.height - self.totalHeight, width: self.bounds.width, height: self.totalHeight))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.toolHeight))
        view.backgroundColor = UIColor.white
        
        //添加自定义分割线
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0.0, y: view.frame.maxY, width: view.bounds.width, height: 0.5)
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(lineLayer)
        
        return view
    }()
    
    private lazy var cancleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: 15.0, y: 0.0, width: 50.0, height: self.topView.frame.height)
        btn.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        
        return btn
    }()
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: self.topView.frame.maxX - 50.0 - 15.0, y: 0.0, width: 50.0, height: self.topView.frame.height)
        btn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)

        return btn
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let picker = UIDatePicker.init(frame: CGRect(x: 0.0, y: self.topView.frame.maxY, width: self.bounds.width, height: self.pickerHeight))
        
        return picker
    }()
    
    deinit {
        debugPrint("###\(self)销毁了###\n")
    }
}


enum AddressType {
    /// 省市区 省市
    case provinceCityArea, provinceCity
}

class AddressPickerTool: UIView {
    
    /// 展示地址控件
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - block: 回调
    class func show(with type: AddressType = .provinceCityArea, block: ((String)->Void)?) {
        
        let picker = AddressPickerTool(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        if picker.isAnimating { return }
        picker.isAnimating = true
        kWindow.addSubview(picker)
        
        picker.callback = block
        picker.showType = type
        
        picker.showView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            
            picker.alpha = 1.0
            picker.showView.transform = CGAffineTransform.identity
            
        }) { (isOk) in
            
            picker.isAnimating = false
        }
    }
    
    private var totalHeight: CGFloat {
        
        return kIsIphoneX ? (240.0 + 34.0) : (240.0)
    }
    private let toolHeight: CGFloat = 40.0
    private let pickerHeight: CGFloat = 200.0
    /// 是否在执行动画
    private var isAnimating: Bool = false
    /// 回调
    private var callback: ((String)->Void)?
    /// 类型
    private var showType: AddressType!
    /// 市对应的下标
    private var cityIndex: Int = 0
    /// 区对应的下标
    private var areaIndex: Int = 0
    /// 地区
    private var provinceStr: String!
    private var cityStr: String!
    private var areaStr: String!
    
    /// 省
    private lazy var allProvinces: [String] = {
        var arr: [String] = []
        for emelemt in self.dataList {
            
            let dic = emelemt as! NSDictionary
            arr.append(dic["province"] as! String)
        }
        return arr
    }()
    /// 市
    private var allCitys: [String] {
        var arr: [String] = []
        let emelemt = self.dataList[self.cityIndex > self.dataList.count - 1 ? 0 : self.cityIndex]
        let dic = emelemt as! NSDictionary
        let citys = dic["citys"] as! NSArray
        for cityEmelemt in citys {
            
            let dict = cityEmelemt as! NSDictionary
            arr.append(dict["city"] as! String)
        }
        if self.cityIndex <= 3 {
            
            let dict = citys[self.areaIndex > citys.count - 1 ? 0 : self.areaIndex] as! NSDictionary
            arr = dict["districts"] as! [String]
        }
        
        return arr
    }
    /// 区
    private var allAreas: [String] {
        var arr: [String] = []
        let emelemt = self.dataList[self.cityIndex > self.dataList.count - 1 ? 0 : self.cityIndex]
        let dic = emelemt as! NSDictionary
        let citys = dic["citys"] as! NSArray
        
        let dict = citys[self.areaIndex > citys.count - 1 ? 0 : self.areaIndex] as! NSDictionary
        arr = dict["districts"] as! [String]
        
        return arr
    }
    /// 加载plist文件
    private lazy var dataList: NSArray = {
        let plistPath = Bundle.main.path(forResource: "Address", ofType: "plist")!
        let arr = NSArray(contentsOfFile: plistPath)!
        
        return arr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(self.showView)
        self.showView.addSubview(self.topView)
        self.topView.addSubview(self.cancleBtn)
        self.topView.addSubview(self.sureBtn)
        self.showView.addSubview(self.addressPicker)
    }
    
    /// 取消事件
    @objc private func cancleAction() {
        
        if self.isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
            
        }) { (isOK) in
            
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    /// 确定事件
    @objc private func sureAction() {
        
        self.cancleAction()
        self.callback?(self.provinceStr + " " + self.cityStr + (self.showType == .provinceCity ? ("") : (" \(self.areaStr)")))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
    private lazy var showView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: self.bounds.height - self.totalHeight, width: self.bounds.width, height: self.totalHeight))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.toolHeight))
        view.backgroundColor = UIColor.white
        
        //添加自定义分割线
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0.0, y: view.frame.maxY, width: view.bounds.width, height: 0.5)
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(lineLayer)
        
        return view
    }()
    
    private lazy var cancleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: 15.0, y: 0.0, width: 50.0, height: self.topView.frame.height)
        btn.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        
        return btn
    }()
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: self.topView.frame.maxX - 50.0 - 15.0, y: 0.0, width: 50.0, height: self.topView.frame.height)
        btn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var addressPicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0.0, y: self.topView.frame.maxY, width: self.bounds.width, height: self.pickerHeight))
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    deinit {
        debugPrint("###\(self)销毁了###\n")
    }
}

extension AddressPickerTool: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return self.showType == .provinceCity ? (2) : (3)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return self.allProvinces.count
        }
        if self.showType == .provinceCity {
            
            return self.allCitys.count
            
        } else {
            
            return component == 1 ? self.allCitys.count : self.allAreas.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return self.allProvinces[row]
        }
        if self.showType == .provinceCity {
            
            return self.allCitys[row]
            
        } else {
            
            return component == 1 ? self.allCitys[row] : self.allAreas[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.showType == .provinceCity {
            
            if component == 0 {
                
                self.cityIndex = row
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                
                self.provinceStr = self.allProvinces[row]
                self.cityStr = self.allCitys[0]
                
            } else {
                
                self.cityStr = self.allCitys[row]
            }
            
        } else {
            
            if component == 0 {
                
                self.cityIndex = row
                self.areaIndex = 0
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                
                self.provinceStr = self.allProvinces[row > self.allProvinces.count - 1 ? (0) : (row)]
                self.cityStr = self.allCitys[0]
                self.areaStr = self.allAreas[0]
                
            } else if component == 1 {
                
                self.areaIndex = row
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                
                self.cityStr = self.allCitys[row]
                self.areaStr = self.allAreas[0]
                
            } else {
                
                self.areaStr = self.allAreas[row]
            }
        }
    }
}

