//
//  CellFavourit.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

@objc protocol PotocolCellFavourite{
    @objc optional func tapOnfavouritecell(cell :CellFavourit)
    @objc optional func tapOnfavouritePlacescell(cell :CellFavouritePlaces)
}

class CellFavourit: UITableViewCell {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    
    @IBOutlet weak var BtnHeart: UIButton!
    @IBOutlet weak var lblFavouritProduct: UILabel!
    @IBOutlet weak var lblFavouritProductprice: UILabel!
    @IBOutlet weak var imgFavourit: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    var delegate : PotocolCellFavourite?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         lblFavouritProduct.text = nil
         imgFavourit.image = nil
         ratingView.rating = 0.0
         lblFavouritProductprice.text = nil
    }
    
    func setupCellData(_ product: Products){
        if(lang == "en"){
        lblFavouritProduct.text = product.productName?.en
        }else{
            lblFavouritProduct.text = product.productName?.ar
        }
        imgFavourit.sd_setShowActivityIndicatorView(true)
        imgFavourit.sd_setIndicatorStyle(.gray)
        imgFavourit.sd_setImage(with: URL(string: product.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        lblFavouritProductprice.text = (currency == "usd") ? "$\(product.price?.usd ?? 0)" : "AED\(product.price?.aed ?? 0)"
        ratingView.rating = Double(product.averageRating ?? 0)
    }
    
    @IBAction func heartClick(_ sender: Any){
        delegate?.tapOnfavouritecell!(cell: self)
    }
}
