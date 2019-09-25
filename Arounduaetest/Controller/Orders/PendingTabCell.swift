//
//  PendingTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

protocol OrderProtocol{
    func orderEyetapped(cell:PendingTabCell)
}

class PendingTabCell: UITableViewCell {

    @IBOutlet weak var lblpstatus: UILabel!
    @IBOutlet weak var lblpDate: UILabel!
    @IBOutlet weak var orderlblTxt: UILabel!
    @IBOutlet weak var lblChargestxt: UILabel!
    @IBOutlet weak var lblDatetxt: UILabel!
    @IBOutlet weak var lblStatusTxt: UILabel!
    @IBOutlet weak var lblcombinatonDetail: UILabel!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var boxesImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var eyeBtn: UIButton!
    var delegate: OrderProtocol?
    
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
        orderlblTxt.text = order.payerId
        lblChargestxt.text = "$\(order.charges ?? 0)"
        
        str = "Quantity: \(order.orderDetails?.count ?? 0) "
        
        for obj in (order.orderDetails?.first?.combinationDetail) ?? []{
            str += " "
            if(lang == "en"){
                 str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
            }else{
                 str += (obj.feature?.title?.ar ?? "")+": "+(obj.characteristic?.title?.ar ?? "")
            }
        }
        
        lblcombinatonDetail.text = str

        let string = order.createdAt!
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        
        lblDatetxt.text = dateString
        lblStatusTxt.text = order.status?.capitalized
        
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
    
    func setupSellerCellData(order:SellerOrder){
        orderlblTxt.text = order.product?.productName?.en?.capitalized
        lblChargestxt.text = "$\(order.price?.usd ?? 0)"
      
        str = "Quantity: \(order.quantity ?? 0) "
        
        for obj in (order.combinationDetail) ?? []{
            str += " "
            if(lang == "en"){
            str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
            }else
            {
                 str += (obj.feature?.title?.ar ?? "")+": "+(obj.characteristic?.title?.ar ?? "")
            }
        }

        lblcombinatonDetail.text = str
        let string = order.createdAt!
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
    
        lblDatetxt.text = dateString
        lblStatusTxt.text = order.status?.capitalized
        
        eyeBtn.layer.cornerRadius = 15
        eyeBtn.clipsToBounds = true
        
        if(order.quantity ?? 0) > 0{
            boxesImage.image = #imageLiteral(resourceName: "Slide")
            shadowImage.image = #imageLiteral(resourceName: "Bg")
        }else{
            boxesImage.image = nil
            shadowImage.image = nil
        }
        
        confirmImage.sd_setShowActivityIndicatorView(true)
        confirmImage.sd_setIndicatorStyle(.gray)
        confirmImage.sd_setImage(with: URL(string: order.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    @IBAction func eyeTapped(_ sender:UIButton){
        self.delegate?.orderEyetapped(cell: self)
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
