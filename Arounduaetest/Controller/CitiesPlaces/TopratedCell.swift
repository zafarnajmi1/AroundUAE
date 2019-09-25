//
//  TopratedCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

protocol topratedCellDelegate{
    func favouriteTapped(cell: TopratedCell)
}

class TopratedCell: UICollectionViewCell {
    
    @IBOutlet weak var btnToprated: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var placeTitle: UIImageView!
    @IBOutlet weak var favroutieImage: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var delegate: topratedCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.btnToprated.layer.cornerRadius = 15
        self.btnToprated.layer.borderWidth = 0.5
        self.btnToprated.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func awakeFromNib() {
        cosmosView.rating = 0.0
        title.text = nil
        placeTitle.image = nil
        favroutieImage.image = nil
    }
    
    func setupPlaceCell(_ places:Places){
        cosmosView.rating = Double(places.averageRating!)
        if(lang == "en"){
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
            self.btnToprated.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.favroutieImage.image = #imageLiteral(resourceName: "Favourite")
            self.btnToprated.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
         }
        }else{
            self.favroutieImage.isHidden = true
            self.btnToprated.isHidden = true
        }
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}


