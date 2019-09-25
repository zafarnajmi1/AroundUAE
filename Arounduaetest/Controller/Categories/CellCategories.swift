//
//  CellCategories.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage

class CellCategories: UICollectionViewCell {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var imgCategory: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    
    override func awakeFromNib() {
        imgCategory.image = nil
        lblCategory.text = ""
    }
    
    func setupCell(_ group:Groups, groupImage:UIImage?){
        lblCategory.text =  (lang == "en") ? group.title?.en : group.title?.ar
        if let Image = groupImage {
            imgCategory.image = Image
        }else{

            imgCategory.sd_setShowActivityIndicatorView(true)
            imgCategory.sd_setIndicatorStyle(.gray)
            imgCategory.sd_setImage(with: URL(string: group.image ?? ""))
        }
    }
}
