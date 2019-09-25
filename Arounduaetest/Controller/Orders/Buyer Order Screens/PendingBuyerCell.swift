//
//  PendingBuyerCell.swift
//  Arounduaetest
//
//  Created by Apple on 09/11/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

//
//  PendingTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

protocol PendingBuyerProtocol{
    func orderEyetapped(cell:PendingBuyerCell)
}

class PendingBuyerCell: UITableViewCell {
    
    @IBOutlet weak var lblpstatus: UILabel!
    @IBOutlet weak var lblpDate: UILabel!
    @IBOutlet weak var lbltotalAmount: UILabel!
    @IBOutlet weak var orderlblTxt: UILabel!
    @IBOutlet weak var lblChargestxt: UILabel!
    @IBOutlet weak var lblDatetxt: UILabel!
    @IBOutlet weak var lblStatusTxt: UILabel!
    @IBOutlet weak var lblTotalProductsTxt: UILabel!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var boxesImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var eyeBtn: UIButton!
    var delegate: PendingBuyerProtocol?
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var str = ""
    var x = " "
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderlblTxt.text = nil
        lblChargestxt.text = nil
        lblDatetxt.text = nil
        lblStatusTxt.text = nil
        confirmImage.image = nil
        boxesImage.image = nil
        shadowImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblpDate.text = "Date".localized
        self.lblpstatus.text = "Status".localized
    }
    
    func setupCellData(order:OrderData){
        orderlblTxt.text = "Order # \(order.orderNumber ?? "")"
        lblChargestxt.text = "$\(order.charges ?? 0)"
        lblTotalProductsTxt.text = "0\(order.orderDetails?.count ?? 0)"
        
        str = "Quantity: \(order.orderDetails?.count ?? 0) "
        
        for obj in (order.orderDetails?.first?.combinationDetail) ?? []{
            str += " "
            if(lang == "en"){
                str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
            }else{
                str += (obj.feature?.title?.ar ?? "")+": "+(obj.characteristic?.title?.ar ?? "")
            }
        }
        
        //lblcombinatonDetail.text = str
        
        let string = order.createdAt!
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "d MMM, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        var Confirmed = 0
        var Shipped = 0
        var Completed = 0
        lblDatetxt.text = dateString
        for obj in order.orderDetails!{
            if obj.status ?? "" == "shipped"{
                Shipped += 1
            }
            if obj.status ?? "" == "confirmed"{
                Confirmed += 1
            }
            if obj.status ?? "" == "completed"{
                Completed += 1
            }
        }
        lblStatusTxt.text = "Confirmed(\(Confirmed)), "+"Shipped(\(Shipped)), "+"Completed(\(Completed)) "
        
        eyeBtn.layer.cornerRadius = 15
        eyeBtn.clipsToBounds = true
        
        if(order.orderDetails?.count ?? 0) > 0{
            boxesImage.image = #imageLiteral(resourceName: "Slide")
            shadowImage.image = #imageLiteral(resourceName: "Bg")
        }else{
            boxesImage.image = nil
            shadowImage.image = nil
        }
        
        confirmImage.sd_setShowActivityIndicatorView(true)
        confirmImage.sd_setIndicatorStyle(.gray)
        confirmImage.sd_setImage(with: URL(string: order.orderDetails?.first?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    @IBAction func eyeTapped(_ sender:UIButton){
        self.delegate?.orderEyetapped(cell: self)
    }
}
