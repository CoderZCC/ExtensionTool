//
//  CellPlayerModel.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellPlayerModel: NSObject {
    
    var coverUrl: String = ""
    var videoUrl: String = ""
}

class CellPlayerViewModel: NSObject {

    var dataList: [CellPlayerModel] = []
    var reloadDataCallBack: (()->Void)?
    
    func getData() {
        
        self.dataList = []
        for (index, str) in self.videoArr.enumerated() {
            
            let model = CellPlayerModel()
            model.coverUrl = self.imageArr[index]
            model.videoUrl = str
            
            self.dataList.append(model)
        }
        self.reloadDataCallBack?()
    }
    
    /// 视频地址
    private let videoArr: [String] = ["http://res.supervolleyball.com/SVBallMp4/android_1561533692188893.mp4", "http://res.supervolleyball.com/SVBallMp4/ios_20180807054656.mp4", "http://res.supervolleyball.com/SVBallMp4/ios_20180807041846.mp4", "http://res.supervolleyball.com/SVBallMp4/android_3801533622947134.mp4", "http://res.supervolleyball.com/SVBallMp4/ios_20180619051643.mp4", "http://res.supervolleyball.com/SVBallMp4/android_1441528796015818.mp4", "http://res.supervolleyball.com/SVBallMp4/android_1441528795887853.mp4"]
    
    /// 封面地址
    private let imageArr: [String] = ["http://res.supervolleyball.com/SVBallPic/android_1561533692188722.jpg", "http://res.supervolleyball.com/SVBallPic/ios_201808070547010.jpg", "http://res.supervolleyball.com/SVBallPic/android_3801533623994214.jpg", "http://res.supervolleyball.com/SVBallPic/android_3801533622946840.jpg", "http://res.supervolleyball.com/SVBallPic/ios_201806190516480.jpg", "http://res.supervolleyball.com/SVBallPic/android_1441528796015670.jpg", "http://res.supervolleyball.com/SVBallPic/android_1441528795887265.jpg"]

}
