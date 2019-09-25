//
//  CellMenu.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

class CellMenu: UITableViewCell {

    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    
    override func awakeFromNib() {
        lblMenu.text = nil
        imgMenu.image = nil
    }
    
    func setupMenu(_ title: String, imagestr: String){
        lblMenu.text = title
        if let image = UIImage(named: imagestr){
            imgMenu.image = image
        }else{
            imgMenu.sd_setShowActivityIndicatorView(true)
            imgMenu.sd_setIndicatorStyle(.gray)
            imgMenu.sd_setImage(with: URL(string:imagestr))
        }
    }
}
