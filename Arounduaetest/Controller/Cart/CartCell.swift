//
//  CartCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

protocol Cartprotocol{
    func tapOnDeleteProduct(cell:CartCell)
    func tapQuantity(cell:CartCell)
}

class CartCell: UITableViewCell {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewStepper: GMStepperCart!{
        didSet{
            self.delegate?.tapQuantity(cell: self)
        }
    }
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblProductname: UILabel!
    var delegate:Cartprotocol?
    var increaseValue = false
    var decreaseValue = false
    var previousValue = 0.0
    
    override func awakeFromNib() {
        imgProduct.clipsToBounds = true
        imgProduct.image = nil
        lblProductPrice.text = nil
        lblusername.text = nil
        lblProductname.text = nil
    }
    
    func setupCartCell(_ product:ProductUAE){
        imgProduct.sd_setShowActivityIndicatorView(true)
        imgProduct.sd_setIndicatorStyle(.gray)
        imgProduct.sd_setImage(with: URL(string: product.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        let x = (product.price?.usd ?? 0)
        let y = Int(product.quantity ?? 0.0)
        let result = x * y
        lblProductPrice.text = (currency == "usd") ? "$\(result)" : "AED\(product.price?.aed ?? 0)"
        if(lang == "en"){
           lblusername.text = product.product?.productName?.en?.capitalized
           lblProductname.text = product.product?.productName?.en?.capitalized
        }else{
           lblusername.text = product.product?.productName?.ar?.capitalized
           lblProductname.text = product.product?.productName?.ar?.capitalized
        }
        viewStepper.value = product.quantity ?? 0.0
        previousValue = product.quantity ?? 0.0
    }
    
    @IBAction func btnCancelClick(_ sender: Any){
        self.delegate?.tapOnDeleteProduct(cell: self)
    }
    
    @IBAction func btnQuantityClick(_ sender: GMStepperCart){
        if sender.tag == 1{
            if sender.value > previousValue {
                increaseValue = true
                decreaseValue = false
            } else {
                increaseValue = false
                decreaseValue = true
            }
            previousValue = sender.value

          self.delegate?.tapQuantity(cell: self)
        }
        sender.tag = 1
    }
}
