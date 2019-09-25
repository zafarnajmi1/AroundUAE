//
//  GenralCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

class VCCitiesCell: UICollectionViewCell {
    
    @IBOutlet weak var lblGenralName: UILabel!
    @IBOutlet weak var imgGenral: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func awakeFromNib() {
//        lblGenralName.text = nil
//        imgGenral.image = nil
    }
    
    func setupCities(_ city: Cities){
        if(lang == "en"){
         lblGenralName.text = city.title?.en ?? ""
        }else{
         lblGenralName.text = city.title?.ar ?? ""
        }
        imgGenral.sd_setShowActivityIndicatorView(true)
        imgGenral.sd_setIndicatorStyle(.gray)
        imgGenral.sd_setImage(with: URL(string: city.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
}
