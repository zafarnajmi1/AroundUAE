//
//  CellNearBy.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 03/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

protocol CellNearProtocol{
    func addToCartTapped(cell: CellNearBy)
    func favouriteTapped(cell: CellNearBy)
}

class CellNearBy: UICollectionViewCell {
    
    @IBOutlet weak var btnaddtocartnearby: UIButtonMain!
    @IBOutlet weak var lblpricenearby: UILabel!
    @IBOutlet weak var uiviewcomosenearby: CosmosView!
    @IBOutlet weak var lblproductBrandnamenearby: UILabel!
    @IBOutlet weak var lblproductnamenearby: UILabel!
    @IBOutlet weak var btnFavrouitnearby: UIButton!
    @IBOutlet weak var btnFavrouitnearbyImage: UIImageView!
    @IBOutlet weak var imgproductneaby: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    var delegate: CellNearProtocol?
    
    override func awakeFromNib() {
        btnFavrouitnearby.makeRound()
        btnFavrouitnearby.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
        
        lblpricenearby.text = nil
        uiviewcomosenearby.rating = 0.0
        lblproductnamenearby.text = nil
        imgproductneaby.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.btnFavrouitnearby.layer.cornerRadius = 15
        self.btnFavrouitnearby.layer.borderWidth = 0.5
        self.btnFavrouitnearby.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupNearbyData(product:Products){
        if(lang == "en"){
        lblproductnamenearby.text = product.productName?.en
        }else{
            lblproductnamenearby.text = product.productName?.ar
        }
        uiviewcomosenearby.rating = Double(product.averageRating ?? 0)
        imgproductneaby.sd_addActivityIndicator()
        imgproductneaby.sd_setIndicatorStyle(.gray)
        lblpricenearby.text = (currency == "aed") ?
            "AED\(product.price?.aed ?? 0.0)" : "$\(product.price?.usd ?? 0)"
        imgproductneaby.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        
        if AppSettings.sharedSettings.accountType == "seller"{
            btnFavrouitnearby.isHidden = true
            btnaddtocartnearby.isHidden = true
        }
        print(product.isFavourite)
        if (AppSettings.sharedSettings.user.favouriteProducts?.contains((product._id!)))!{
            self.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite")
            self.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
        }
    }
    
    @IBAction func btnaddtocartclicknearby(_ sender: Any){
        self.delegate?.addToCartTapped(cell: self)
    }
    
    @IBAction func btnfavrouitClicknearby(_ sender: Any){
        self.delegate?.favouriteTapped(cell: self)
    }
}
