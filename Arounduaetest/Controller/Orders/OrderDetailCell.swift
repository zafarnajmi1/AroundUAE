//
//  OrderDetailCell.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

protocol OrderDetailPrortocol {
    func tapOnReceived(cell:OrderDetailCell)
}

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var lblorderstorname: UILabel!
    @IBOutlet weak var lblorderstatus: UILabel!
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblOrderList: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCharges: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var boxesImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var str = ""
    var delegate: OrderDetailPrortocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblOrderName.text = ""
        lblOrderList.text = ""
        storeName.text = ""
        lblStatus.text = ""
        lblCharges.text = ""
        boxesImage.image = nil
        shadowImage.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblorderstatus.text = "Status".localized
        self.lblorderstorname.text = "Store Name".localized
        self.cellBtn.setTitle("Received".localized, for: .normal)
    }
    func setupData(order:SomeOrderDetails){
        if (order.status ?? "") == "shipped"{
           cellBtn.isEnabled = true
           cellBtn.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2039215686, blue: 0.3294117647, alpha: 1)
        }else{
            cellBtn.isEnabled = false
            cellBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        str = "Quantity: \(order.quantity ?? 0)"
        
        for obj in (order.combinationDetail) ?? []{
            str += " "
            if lang == "en"{
                str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
            }else{
                str += (obj.feature?.title?.ar ?? "")+": "+(obj.characteristic?.title?.ar ?? "")
            }
        }

        if(order.quantity ?? 0) > 0{
            boxesImage.image = #imageLiteral(resourceName: "Slide")
            shadowImage.image = #imageLiteral(resourceName: "Bg")
        }else{
            boxesImage.image = nil
            shadowImage.image = nil
        }
        
        lblOrderName.text = (lang == "en") ? order.product?.productName?.en : order.product?.productName?.ar
        lblOrderList.text = str
        storeName.text = (lang == "en") ? order.product?.store?.storeName?.en ?? "" : order.product?.store?.storeName?.ar ?? ""
        lblStatus.text = order.status
        lblCharges.text = "$\(order.price?.usd ?? 0)"
        orderImage.sd_setShowActivityIndicatorView(true)
        orderImage.sd_setIndicatorStyle(.gray)
        orderImage.sd_setImage(with: URL(string: (order.image ?? "")), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    @IBAction func actonBtn(_ sender: UIButton){
        delegate?.tapOnReceived(cell: self)
    }
}
