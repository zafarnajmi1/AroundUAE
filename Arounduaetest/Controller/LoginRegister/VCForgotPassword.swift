//
//  VCForgotPassword.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCForgotPassword: BaseController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var txtEnterEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButtonMain!
    @IBOutlet weak var btnResend: UIButtonMain!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.Forgotlocalaiz()
        self.title = "Forgot Password".localized
    }
    
    func Forgotlocalaiz(){
        
        self.lblForgotPassword.text = "Forgot your password? Enter your email below ".localized
        self.txtEnterEmail.setPadding(left: 10, right: 0)
        self.txtEnterEmail.placeholder  = "Please Enter Email".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        self.btnResend.setTitle("Cancel".localized, for: .normal)
        if(lang == "ar"){
            self.showArabicBackButton()
            self.txtEnterEmail.textAlignment = .right
        }else if(lang == "en"){
            self.addBackButton()
            self.txtEnterEmail.textAlignment = .left
        }
    }
    
    private func isCheck()->Bool{
        guard let email = txtEnterEmail.text, email.count > 0 else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid Email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if isCheck(){
            forgotPassword(useremail: txtEnterEmail.text!)
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func forgotPassword(useremail: String){
        startLoading("")
        AuthManager().forgotPassword(useremail,
        successCallback:
        {[weak self](response) in
             DispatchQueue.main.async {
                if let forgetesponse = response{
                    if(forgetesponse.success ?? false == true){
                        self?.finishLoading()
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.moveToResetPassword()
                        })
                    }else{
                        self?.finishLoading()
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.finishLoading()
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "",  completionHandler: nil)
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message,completionHandler: nil)
            }
        }
    }
    
    private func moveToResetPassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCResetPassword") as! VCResetPassword
        vc.email = txtEnterEmail.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
