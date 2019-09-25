//
//  CellC.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class productlistingcell: UICollectionViewCell {
    
    @IBOutlet var UIButtonFavourite: UIButton!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    
    override func awakeFromNib(){
        UIButtonFavourite.makeRound()
        UIButtonFavourite.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
