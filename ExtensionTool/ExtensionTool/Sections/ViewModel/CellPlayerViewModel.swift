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
    private let videoArr: [String] = ["http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.mp4","http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.mp4","http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.mp4","http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.mp4","http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.mp4","http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.mp4","http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.mp4","http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.mp4","http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.mp4","http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.mp4"]
    
    /// 封面地址
    private let imageArr: [String] = ["http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.jpg","http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.jpg","http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.jpg","http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.jpg", "http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.jpg","http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.jpg", "http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.jpg", "http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.jpg", "http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.jpg","http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.jpg"]
    
    
    
}
