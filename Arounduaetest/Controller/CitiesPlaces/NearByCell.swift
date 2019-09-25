//
//  NearByCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

protocol nearbyCellDelegate{
    func favouriteTapped(cell: NearByCell)
}

class NearByCell: UICollectionViewCell {
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var btnFavourit: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var placeTitle: UIImageView!
    @IBOutlet weak var favroutieImage: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var delegate: nearbyCellDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.btnFavourit.layer.cornerRadius = 15
        self.btnFavourit.layer.borderWidth = 0.5
        self.btnFavourit.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func awakeFromNib() {
        cosmosView.rating = 0.0
        title.text = nil
        placeTitle.image = nil
        favroutieImage.image = nil
    }
    
    func setupPlaceCell(_ places:Places){
        cosmosView.rating = Double(places.averageRating!)
        if(lang == "en")
        {
        title.text = places.title?.en ?? ""
        }else{
             title.text = places.title?.ar ?? ""
        }
        placeTitle.sd_setShowActivityIndicatorView(true)
        placeTitle.sd_setIndicatorStyle(.gray)
        placeTitle.sd_setImage(with: URL(string: places.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        
        if AppSettings.sharedSettings.accountType != "seller"{
            if AppSettings.sharedSettings.user.favouritePlaces?.contains((places._id!)) ?? false{
                self.favroutieImage.image = #imageLiteral(resourceName: "Favourite-red")
                self.btnFavourit.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                self.favroutieImage.image = #imageLiteral(resourceName: "Favourite")
                self.btnFavourit.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.09803921569, blue: 0.1490196078, alpha: 1)
            }
        }else{
            self.favroutieImage.isHidden = true
            self.btnFavourit.isHidden = true
        }
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}
