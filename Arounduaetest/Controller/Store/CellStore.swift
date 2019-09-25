//
//  CellStore.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

protocol storeCellDelegate{
    func favouriteTapped(cell: CellStore)
    func addToCartTapped(cell: CellStore)
}

class CellStore: UICollectionViewCell {
    
    @IBOutlet var UIButtonFavourite: UIButton!
    @IBOutlet var favouriteImage: UIImageView!
    @IBOutlet var addtocartBtn: UIButton!
    @IBOutlet var imgProducts: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    var delegate: storeCellDelegate?
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    
    override func awakeFromNib(){
        imgProducts.image = nil
        lblProductName.text = nil
        productPrice.text = nil
        UIButtonFavourite.somemakeRound()
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.UIButtonFavourite.layer.cornerRadius = 15
        self.UIButtonFavourite.layer.borderWidth = 0.5
        self.UIButtonFavourite.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupProductCell(product:StoreProduct){
        lblProductName.text = (lang == "en") ? product.productName?.en : product.productName?.ar
        ratingView.rating = Double(product.averageRating ?? 0)
        addtocartBtn.setTitle( "Add to Cart".localized, for: .normal) 

        imgProducts.sd_setShowActivityIndicatorView(true)
        imgProducts.sd_setIndicatorStyle(.gray)
        productPrice.text = (currency == "usd") ? "$\(product.price?.usd ?? 0)" : "AED\(product.price?.aed ?? 0)"
        print("Loading",product.images?.first?.path)
        imgProducts.sd_setImage(with: URL(string: product.images![0].path ?? ""))
        if AppSettings.sharedSettings.accountType == "seller"{
           UIButtonFavourite.isHidden = true
           addtocartBtn.isHidden = true
        }
       
        if AppSettings.sharedSettings.user.favouriteProducts?.contains((product._id!)) ?? false{
            self.favouriteImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.UIButtonFavourite.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.favouriteImage.image = #imageLiteral(resourceName: "Favourite")
            self.UIButtonFavourite.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.1176470588, blue: 0.0862745098, alpha: 1)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton){
        self.delegate?.addToCartTapped(cell: self)
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}
