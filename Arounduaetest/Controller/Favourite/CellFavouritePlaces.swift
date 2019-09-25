//
//  CellFavouritePlaces.swift
//  AroundUAE
//
//  Created by Macbook on 28/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class CellFavouritePlaces: UITableViewCell {

    @IBOutlet weak var BtnHeart: UIButton!
    @IBOutlet weak var lblFavouritProduct: UILabel!
    @IBOutlet weak var imgFavourit: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
     var delegate : PotocolCellFavourite?
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    override func awakeFromNib() {
        super.awakeFromNib()
        lblFavouritProduct.text = nil
        imgFavourit.image = nil
        ratingView.rating = 0.0
    }
    
    func setupCellData(_ place: Places){
        if(lang == "en")
        {
        lblFavouritProduct.text = place.title?.en
        }else
        {
             lblFavouritProduct.text = place.title?.ar
        }
        ratingView.rating = Double(place.averageRating ?? 0)
        imgFavourit.sd_setShowActivityIndicatorView(true)
        imgFavourit.sd_setIndicatorStyle(.gray)
        imgFavourit.sd_setImage(with: URL(string: place.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    @IBAction func heartClick(_ sender: Any){
        delegate?.tapOnfavouritePlacescell!(cell: self)
    }
}
