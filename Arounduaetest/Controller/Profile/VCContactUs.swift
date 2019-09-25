//
//  VCContactUs.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import DropDown

class VCContactUs: UIViewController{
    
    @IBOutlet weak var appFeedBack: UILabel!
    @IBOutlet weak var txtAppFeedback: UICustomTextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblYourComment: UILabel!
    @IBOutlet weak var titleheaderLbl: UILabel!
    @IBOutlet weak var btnSubmit: UIButtonMain!
    @IBOutlet weak var dropdown: UIButton!
    let menudropDown = DropDown()
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "en"{
            self.addBackButton()
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
        }else{
            self.showArabicBackButton()
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
        }
        txtAppFeedback.delegate = self
        txtAppFeedback.textColor = UIColor.lightGray
        menudropDown.anchorView = dropdown
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.dataSource = ["App Feedback".localized,"Complaint".localized]
        menudropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.appFeedBack.text = item
        }
    }

    override func viewWillAppear(_ animated: Bool){
        self.setNavigationBar()

        titleheaderLbl.text = "What can we Help you with?".localized
        self.title = "Contact Us".localized
        self.appFeedBack.text = "App Feedback".localized
        self.txtAppFeedback.text = "   Comment...".localized
        self.lblName.text = "Name".localized
        self.txtName.placeholder = "Name".localized
        self.lblEmail.text = "Email".localized
        self.txtEmail.placeholder = "Email".localized
        self.lblYourComment.text = "Your Comment".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    private func isCheck()->Bool{
        
        guard let Name = txtName.text, Name.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter your name".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = txtEmail.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Email!".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid Email!".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let comment = txtAppFeedback.text, comment != "Comment..." else{
            self.alertMessage(message: "Please Enter Your Comment!".localized, completionHandler: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func dropDown(_ sender: Any){
        menudropDown.show()
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if isCheck(){
            contactUs(name: txtName.text!, email: txtEmail.text!, comment: txtAppFeedback.text)
        }
    }
    
    private func contactUs(name:String,email:String,comment:String){
        startLoading("")
        IndexManager().contactUs((name,email,self.appFeedBack.text!,comment),
        successCallback:
        {[weak self](response) in
            self?.finishLoading()
            if let contactResponse = response{
                if self?.lang ?? "" == "en"{
                    if contactResponse.success!{
                        
                        self?.alertMessage(message: contactResponse.message?.en ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: contactResponse.message?.en ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    if contactResponse.success!{
                        
                        self?.alertMessage(message: contactResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: contactResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
                
            }else{
                 if self?.lang ?? "" == "en"{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: {
                      self?.navigationController?.popViewController(animated: true)
                    })
                 }else{
                    self?.alertMessage(message: response?.message?.ar ?? "", completionHandler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
        {[weak self](error) in
            self?.finishLoading()
            self?.alertMessage(message: error.message.localized, completionHandler: nil)
        }
    }
}

extension VCContactUs: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtAppFeedback.textColor == UIColor.lightGray {
            txtAppFeedback.text = nil
            txtAppFeedback.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtAppFeedback.text.isEmpty {
            txtAppFeedback.text = "Comment..."
            txtAppFeedback.textColor = UIColor.lightGray
        }
    }
}

