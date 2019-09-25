//
//  VCtest.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCtest: BaseController,UICollectionViewDelegate,UICollectionViewDataSource,IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Top rated")
    }
    
 
    @IBOutlet var collectionViewProduct: UICollectionView!
    
    let imgFaces = [UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color")]
    let lblName = ["Sunglasses","Watches","Smart Phone","Glasses","Wathces","Smart"]
 
 
  
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
      
collectionViewProduct.adjustDesign(width: (view.frame.size.width+24)/2.3)

       
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgFaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productlistingcell", for: indexPath) as! productlistingcell
        cell.imgProduct.image = imgFaces[indexPath.row]
        cell.lblProductName.text = lblName[indexPath.row]
        return cell
        
        
        
    }

  
}



