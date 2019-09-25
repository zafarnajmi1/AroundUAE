//
//  DataCollectionViewCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var imgProducts: UIImageView!
    @IBOutlet weak var lblProducts: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    override func awakeFromNib() {
        imgProducts.image = nil
        lblProducts.text = ""
    }
    
    func setupCell(_ divison:Divisions){
        
        if lang == "en"{
             lblProducts.text = divison.title?.en
        }else{
             lblProducts.text = divison.title?.ar
        }
        imgProducts.sd_setShowActivityIndicatorView(true)
        imgProducts.sd_setIndicatorStyle(.gray)
        imgProducts.sd_setImage(with: URL(string: divison.image ?? ""))
    }
}
 
