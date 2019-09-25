//
//  CellC.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Cosmos

class productlistingcell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAddproduct: UIButtonMain!
    @IBOutlet weak var viewcosmose: CosmosView!
    @IBOutlet weak var lblproductbrandname: UILabel!
    @IBOutlet weak var lblproductname: UILabel!
    @IBOutlet weak var btnFavrouit: UIButton!
    @IBOutlet weak var imgproduct: UIImageView!
    
    override func awakeFromNib() {
        btnFavrouit.makeRound()
        btnFavrouit.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func btnFavrouitclick(_ sender: Any){
        
    }
    
    @IBAction func btnAddtoCartClick(_ sender: Any){

    }
}
