//
//  ViewController.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/9.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        self.view.backgroundColor = UIColor.k_colorWith(rgb: 216.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("###\(self)销毁了###\n")
    }
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    
}

class ViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.layout.minimumLineSpacing = 2.0
        self.layout.minimumInteritemSpacing = 2.0
        self.layout.itemSize = CGSize.init(width: (kWidth - 100.0 - 2.0 * 2.0) / 3.0, height: (kWidth - 100.0 - 2.0 * 2.0) / 3.0)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func btnAction() {
        
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        PhotoBrowserTool.showImage(containerView: collectionView, imgArr: ["1", "2", "3", "4"], currentIndex: indexPath.row, currentImg: cell.imgV.image)        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imgV.image = UIImage.init(named: "\(indexPath.row + 1)")
      
        return cell
    }
}
