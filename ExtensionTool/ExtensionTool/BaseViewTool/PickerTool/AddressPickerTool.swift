//
//  AddressPickerTool.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/21.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class AddressPickerTool: UIView {
    
    /// 展示地址View
    ///
    /// - Parameter callback: 回调
    static func showAddressPickView(callback: ((String)->Void)?) {
        
        let tool = AddressPickerTool.loadXibView()
        tool.alpha = 0.0
        
        if tool.isAnimating { return }
        tool.isAnimating = true
        
        kWindow.addSubview(tool)
        tool.showView.transform = CGAffineTransform(translationX: 0.0, y: kHeight)
        tool.callback = callback
        
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
    /// 对应的下标
    private var areaIndex: Int = 0
    /// 地区
    private var cityStr: String!
    private var areaStr: String!

    private class func loadXibView() -> AddressPickerTool {
        let tool = Bundle.main.loadNibNamed("AddressPickerTool", owner: nil, options: nil)?.first as! AddressPickerTool
        tool.frame = UIScreen.main.bounds
        
        return tool
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cityStr = self.allCitys[0]
        self.areaStr = self.allAreas.values.first![0]
        
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
        self.callback?(self.cityStr + self.areaStr)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
    /// 城市
    private var allCitys: [String] {
        var arr: [String] = []
        for emelent in self.dataList {
            
            let dic: [String: Array<String>] = emelent as! [String: Array<String>]
            arr.append(dic.keys.first!)
        }
        return arr
    }
    /// 地区
    private var allAreas: [String: Array<String>] {
        
        return self.dataList[self.areaIndex] as! [String: Array<String>]
    }
    /// 加载plist文件
    private lazy var dataList: NSArray = {
        let plistPath = Bundle.main.path(forResource: "city", ofType: "plist")
        let arr = NSArray.init(contentsOf: URL.init(fileURLWithPath: plistPath!))!
        
        return arr
    }()
    
    deinit {
        print("###\(self)销毁了###\n")
    }
}

extension AddressPickerTool: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return self.allCitys.count
        }
        return self.allAreas.values.first!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return self.allCitys[row]
        }
        return self.allAreas.values.first![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            self.areaIndex = row
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            self.cityStr = self.allCitys[row]
            self.areaStr = self.allAreas[self.cityStr]![0]

        } else {
            
            self.areaStr = self.allAreas[self.cityStr]![row]
        }
    }
}
