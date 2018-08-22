//
//  AddressPickerTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/21.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

enum AddressType {
    /// 省市区 省市
    case provinceCityArea, provinceCity
}

class AddressPickerTool: UIView {
    
    /// 展示地址View
    ///
    /// - Parameter callback: 回调
    static func showView(type: AddressType = .provinceCityArea, callback: ((String)->Void)?) {
        
        let tool = AddressPickerTool.loadXibView()
        tool.alpha = 0.0
        
        if tool.isAnimating { return }
        tool.isAnimating = true
        
        kWindow.addSubview(tool)
        tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)
        tool.callback = callback
        tool.showType = type
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.showView.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
            tool.isAnimating = false
        }
    }
    
    @IBOutlet private weak var pickerView: UIPickerView!
    /// 展示View
    @IBOutlet private weak var showView: UIView!
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

    private class func loadXibView() -> AddressPickerTool {
        let tool = Bundle.main.loadNibNamed("AddressPickerTool", owner: nil, options: nil)?.first as! AddressPickerTool
        tool.frame = UIScreen.main.bounds
        
        return tool
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.provinceStr = self.allProvinces[0]
        self.cityStr = self.allCitys[0]
        self.areaStr = self.allAreas[0]
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    /// 取消事件
    @IBAction func cancleAction() {
        
        if self.isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
            
        }) { (isOK) in
            
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    /// 确定事件
    @IBAction func sureAction() {
        
        self.cancleAction()
        
        if self.showType == .provinceCity {
            
            self.callback?(self.provinceStr + " " + self.cityStr)

        } else {
            
            self.callback?(self.provinceStr + " " + self.cityStr + " " +  self.areaStr)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
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
        let emelemt = self.dataList[self.cityIndex]
        let dic = emelemt as! NSDictionary
        let citys = dic["citys"] as! NSArray
        for cityEmelemt in citys {
            
            let dict = cityEmelemt as! NSDictionary
            arr.append(dict["city"] as! String)
        }

        return arr
    }
    /// 区
    private var allAreas: [String] {
        var arr: [String] = []
        let emelemt = self.dataList[self.cityIndex]
        let dic = emelemt as! NSDictionary
        let citys = dic["citys"] as! NSArray
        
        let dict = citys[self.areaIndex] as! NSDictionary
        arr = dict["districts"] as! [String]
        
        return arr
    }
    /// 加载plist文件
    private lazy var dataList: NSArray = {
        let plistPath = Bundle.main.path(forResource: "Address", ofType: "plist")!
        let arr = NSArray(contentsOfFile: plistPath)!
        
        return arr
    }()
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}

extension AddressPickerTool: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return self.showType == .provinceCity ? (2) : (3)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.showType == .provinceCity {
            
            if component == 0 {
                
                return self.allProvinces.count
            }
            return self.allCitys.count
            
        } else {
            
            if component == 0 {
                
                return self.allProvinces.count
                
            } else if component == 1 {
                
                return self.allCitys.count
            }
            return self.allAreas.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.showType == .provinceCity {

            if component == 0 {
                
                return self.allProvinces[row]
            }
            return self.allCitys[row]

        } else {
            
            if component == 0 {
                
                return self.allProvinces[row]
                
            } else if component == 1 {
                
                return self.allCitys[row]
            }
        }
        return self.allAreas[row]
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
                
                self.provinceStr = self.allProvinces[row]
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
