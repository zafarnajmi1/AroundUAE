//
//  ManageProductCellCollectionViewCell.swift
//  Arounduaetest
//
//  Created by Apple on 29/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

class ManageProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func awakeFromNib() {
        productname.text = nil
        productPrice.text = nil
        productimage.image = nil
    }
    
    func setupCellData(product:Products){
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
        productname.text = (lang == "en") ? product.productName?.en ?? "": product.productName?.ar ?? ""
        productPrice.text = (currency == "aed") ? "AED\(product.price?.aed ?? 0)" : "$\(product.price?.usd ?? 0)"
        productimage.sd_setShowActivityIndicatorView(true)
        productimage.sd_setIndicatorStyle(.gray)
        productimage.sd_setImage(with: URL(string: product.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
}
