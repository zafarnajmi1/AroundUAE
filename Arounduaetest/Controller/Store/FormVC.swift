//
//  FormVC.swift
//  Arounduaetest
//
//  Created by Apple on 05/11/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class FormVC: UIViewController {

    @IBOutlet weak var lblBillingAddress: UILabel!
    @IBOutlet weak var txtNameField: UITextField!
    @IBOutlet weak var txtPhoneNoField: UITextField!
    @IBOutlet weak var txtEmailField: UITextField!
    @IBOutlet weak var txtAddressoneField: UITextField!
    @IBOutlet weak var txtAddresstwoField: UITextField!
    @IBOutlet weak var txtAddressthreeField: UITextField!
    
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var txtShippingNameField: UITextField!
    @IBOutlet weak var txtShippingPhoneNoField: UITextField!
    @IBOutlet weak var txtShippingEmailField: UITextField!
    @IBOutlet weak var txtShippingAddressoneField: UITextField!
    @IBOutlet weak var txtShippingAddresstwoField: UITextField!
    @IBOutlet weak var txtShippingAddressthreeField: UITextField!
    @IBOutlet weak var lblSameShppingAddress: UILabel!
    @IBOutlet weak var IMG_save_language:UIImageView!
    

    let dispatchGroup = DispatchGroup()
    let paypalname = Notification.Name("paypal")
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Address".localized
        setupAdressData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationBar()
        if lang == "en"{
            addBackButton()
        }else{
            showArabicBackButton()
        }
    }
    
    private func setupAdressData(){
         let user = AppSettings.sharedSettings.user
         txtNameField.text = user.fullName
         txtPhoneNoField.text = user.phone
         txtEmailField.text = user.email
        
            if user.addresses?.count ?? 0 > 1{
                txtAddressoneField.text = user.addresses?[0].address1
                txtAddresstwoField.text = user.addresses?[0].address2
                txtAddressthreeField.text = user.addresses?[0].address3
            }
        
         txtShippingNameField.text = user.fullName
         txtShippingPhoneNoField.text = user.phone
         txtShippingEmailField.text = user.email
        
            if user.addresses?.count ?? 0 > 1{
                txtShippingAddressoneField.text = user.addresses?[1].address1
                txtShippingAddresstwoField.text = user.addresses?[1].address2
                txtShippingAddressthreeField.text = user.addresses?[1].address3
            }
    }
    
    private func isCheck()-> Bool{
        
        guard let name = txtNameField.text, name.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Name".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let phoneno = txtPhoneNoField.text, phoneno.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Phone No".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = txtEmailField.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let addressone = txtAddressoneField.text, addressone.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Address 1".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let shippingname = txtNameField.text, shippingname.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Shipping Name".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let shippingphoneno = txtPhoneNoField.text, shippingphoneno.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Shipping Phone No".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let shippingemail = txtEmailField.text, shippingemail.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Shipping Email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let shippingaddressone = txtAddressoneField.text, shippingaddressone.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Shipping Address 1".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func OnClickSaveLanguage(_ sender: Any) {
        if(self.IMG_save_language.image == #imageLiteral(resourceName: "check_box")){
            self.IMG_save_language.image = #imageLiteral(resourceName: "check_box_checked")
            txtShippingNameField.text = txtNameField.text!
            txtShippingPhoneNoField.text = txtPhoneNoField.text!
            txtShippingEmailField.text = txtEmailField.text!
            txtShippingAddressoneField.text = txtAddressoneField.text!
            txtShippingAddresstwoField.text = txtAddresstwoField.text!
            txtShippingAddressthreeField.text = txtAddressthreeField.text!
            
        }else{
            self.IMG_save_language.image = #imageLiteral(resourceName: "check_box")
            txtShippingNameField.text = ""
            txtShippingPhoneNoField.text = ""
            txtShippingEmailField.text = ""
            txtShippingAddressoneField.text = ""
            txtShippingAddresstwoField.text = ""
            txtShippingAddressthreeField.text = ""
        }
    }
    
    @IBAction func saveAddress(_ sender: UIButton) {
        if !isCheck(){
            return
        }
        callShippingApi(params: (txtShippingNameField.text!,txtShippingEmailField.text!,txtShippingPhoneNoField.text!,
        txtShippingAddressoneField.text!,txtShippingAddresstwoField.text!,txtShippingAddressthreeField.text!,"shipping"))
        
        callBillingApi(params: (txtNameField.text!,txtEmailField.text!,txtPhoneNoField.text!,
         txtAddressoneField.text!,txtAddresstwoField.text!,txtAddressthreeField.text!,"billing"))
    }
    
    private func callShippingApi(params:BillingShippingAddressParams){
        self.startLoading("")
        CartManager().UpdateBillingShipping(params,
            successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if let formrespnse = response{
                        if formrespnse.success!{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
            }
        }
    }
    
    private func callBillingApi(params:BillingShippingAddressParams){
        dispatchGroup.enter()
        CartManager().UpdateBillingShipping(params,
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let formrespnse = response{
                        if formrespnse.success!{
                            NotificationCenter.default.post(name: Notification.Name("paypal"), object: nil)
                            self?.navigationController?.popViewController(animated: true)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
            }
        }
    }
}
