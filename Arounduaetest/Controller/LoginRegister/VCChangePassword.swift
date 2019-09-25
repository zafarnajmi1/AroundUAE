//
//  VCChangePassword.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCChangePassword: BaseController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var lblEnterNewPassword: UILabel!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnCancel: UIButtonMain!
    @IBOutlet weak var btnUpdate: UIButtonMain!
    var email: String!
    var code: String!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        code = "8008"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        //self.addBackButton()
        self.setupLocalization()
    }
    
    private func setupLocalization(){
        self.title = "Change Password".localized
        self.lblEnterNewPassword.text = "Enter your new password and then confirm it to change your account password".localized
        self.txtOldPassword.placeholder = "Old Password".localized
        self.txtNewPassword.placeholder = "New Password".localized
        self.txtConfirmPassword.placeholder = "Confirm Password".localized
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        self.btnUpdate.setTitle("Update".localized, for: .normal)
        
        if (lang == "ar")
        {
            self.showArabicBackButton()
            self.txtNewPassword.textAlignment = .right
            self.txtOldPassword.textAlignment = .right
            self.txtConfirmPassword.textAlignment = .right
            
        }else if(lang == "en")
        {
            self.addBackButton()
            self.txtNewPassword.textAlignment = .left
            self.txtOldPassword.textAlignment = .left
            self.txtConfirmPassword.textAlignment = .left
        }
        
    }
    
    
    private func isCheck()->Bool{
        
        guard let oldPassword = txtOldPassword.text, oldPassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Old Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if oldPassword.count < 6 {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "password must contain 6 characters".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let newPassword = txtNewPassword.text, newPassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter New Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
         }
        
        if newPassword.count < 6 {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "password must contain 6 characters".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let confirmPassword = txtConfirmPassword.text, confirmPassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Confirm Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if confirmPassword.count < 6 {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "password must contain 6 characters".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let confirmpassword = txtConfirmPassword.text, confirmpassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Confirm Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }

    @IBAction func btnUpdateClick(_ sender: Any){
        if isCheck(){
           changePassword(txtOldPassword.text!,newpassword: txtNewPassword.text!, confirmpassword: txtConfirmPassword.text!)
        }
    }
    
    private func changePassword(_ oldpassword:String,newpassword:String,confirmpassword:String){
        startLoading("")
        AuthManager().changePassword((oldpassword,newpassword,confirmpassword),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let Response = response{
                    if(Response.success ?? false == true){
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "",completionHandler: {
                    self?.navigationController?.popViewController(animated: true)})
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message,completionHandler: {
                self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any)    {
        self.navigationController?.popViewController(animated: true)
    }
}
