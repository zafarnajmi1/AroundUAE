//
//  SellerOrderDetail.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

class SellerOrderDetail: UIViewController {

    @IBOutlet weak var sellerOrderImage: UIImageView!
    @IBOutlet weak var sellerNasme: UILabel!
    @IBOutlet weak var sellerPhoneNumber: UILabel!
    @IBOutlet weak var sellerEmail: UILabel!
    @IBOutlet weak var shippingaddresss: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var shippedBtn: UIButton!
    
    @IBOutlet weak var boxesImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    var sellerOrder:SellerOrder!
    var storeid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOrderDetails()
        if(sellerOrder.status ?? "") != "shipped"{
            shippedBtn.isEnabled = true
            shippedBtn.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2039215686, blue: 0.3294117647, alpha: 1)
        }else{
            shippedBtn.isEnabled = false
            shippedBtn.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        }
    }
    
    private func setupOrderDetails(){
        sellerOrderImage.sd_setShowActivityIndicatorView(true)
        sellerOrderImage.sd_setIndicatorStyle(.gray)
        sellerOrderImage.sd_setImage(with: URL(string:sellerOrder.order?.user?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        
        orderImage.sd_setShowActivityIndicatorView(true)
        orderImage.sd_setIndicatorStyle(.gray)
        orderImage.sd_setImage(with: URL(string:sellerOrder.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        
        sellerNasme.text = sellerOrder.order?.user?.fullName
        sellerPhoneNumber.text = sellerOrder.order?.user?.phone
        sellerEmail.text = sellerOrder.order?.user?.email
        
        if((sellerOrder.order?.addresses?.count) ?? 0) > 1{
          shippingaddresss.text = sellerOrder.order?.addresses?[1].address1
        }else{
          shippingaddresss.text = sellerOrder.order?.addresses?.first?.address1
        }
        
        if(sellerOrder.quantity ?? 0) > 0{
            boxesImage.image = #imageLiteral(resourceName: "Slide")
            shadowImage.image = #imageLiteral(resourceName: "Bg")
        }else{
            boxesImage.image = nil
            shadowImage.image = nil
        }
        billingAddress.text = sellerOrder.order?.addresses?.first?.address1
        
        let string = sellerOrder.createdAt!
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "d MMM, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        orderDate.text = dateString
        orderStatus.text = sellerOrder.status?.capitalized
        orderNumber.text = (lang == "en") ? sellerOrder.product?.productName?.en?.capitalized : sellerOrder.product?.productName?.ar?.capitalized
        orderPrice.text = (currency == "aed") ? "$\(sellerOrder.price?.aed ?? 0)" : "$\(sellerOrder.price?.usd ?? 0)"
        var str = ""
        str = "Quantity: \(sellerOrder.quantity ?? 0) "
        
        for obj in (sellerOrder?.combinationDetail) ?? []{
            str += " "
            if lang == "en"{
                str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
            }else{
                str += (obj.feature?.title?.ar ?? "")+": "+(obj.characteristic?.title?.ar ?? "")
            }
        }
        orderQuantity.text = str
    }
    
    @IBAction func shippedOrder(_ sender: UIButton) {
        
        let alert = UIAlertController(title:"Alert", message: "Do you want to ship the order??", preferredStyle: .alert)
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.startLoading("")
            OrderManager().ShipOrderDetail(self.sellerOrder._id ?? "", storeid: self.storeid,
            successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.finishLoading()
                        if let shippedResponse = response{
                            if shippedResponse.success!{
                                self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                    NotificationCenter.default.post(name: Notification.Name("OrderShipped"), object: nil)
                                    self?.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                    self?.navigationController?.popViewController(animated: true)
                                })
                            }
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }
                },
                failureCallback:
                {[weak self](error) in
                    DispatchQueue.main.async {
                        self?.finishLoading()
                        self?.alertMessage(message: error.message, completionHandler: nil)
                }
            })
        }
        let actionno = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction) in
            
        }
        alert.addAction(actionyes)
        alert.addAction(actionno)
        self.present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.addBackButton()
        self.title = "Order Detail"
    }
}
