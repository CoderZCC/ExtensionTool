//
//  CellPlayerCell.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/8/7.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CellPlayerCell: UITableViewCell {

    @IBOutlet weak var coverImgV: UIImageView!
    
    var model: CellPlayerModel! {
        willSet {
            
            self.coverImgV.k_setImage(url: newValue.coverUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
