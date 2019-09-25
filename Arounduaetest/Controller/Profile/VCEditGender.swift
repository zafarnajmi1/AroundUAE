//
//  VCEditGender.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 02/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import DLRadioButton

class VCEditGender: UIViewController {
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var maleRadio: DLRadioButton!
    @IBOutlet weak var femaleRadio: DLRadioButton!
    
    @IBOutlet weak var editGender: UILabel!
    @IBOutlet weak var genderlbl: UILabel!
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.backView.addGestureRecognizer(tap)
        
        if gender == "male"{
            maleRadio.isSelected = true
        }else{
            femaleRadio.isSelected = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        editGender.text = "Edit Gender".localized
        genderlbl.text = "Please Select your Gender".localized
        
        maleRadio.setTitle("Male".localized, for: .normal)
        femaleRadio.setTitle("Female".localized, for: .normal)
        
        updateBtn.setTitle("Update".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)
    }
    
    @IBAction func female(_ sender: DLRadioButton) {
        femaleRadio.isSelected = true
        maleRadio.isSelected = false
    }
    
    @IBAction func male(_ sender: DLRadioButton) {
        femaleRadio.isSelected = false
        maleRadio.isSelected = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any){
        if maleRadio.isSelected{
            AppSettings.sharedSettings.user.gender = "male"
        }else{
            AppSettings.sharedSettings.user.gender = "female"
        }
        updateProfile(AppSettings.sharedSettings.user)
    }
    
    private func updateProfile(_ user:User){
        
        let uiimage = UIImage(named: "def")
        let params = (user.fullName ?? "", user.email ?? "", user.phone ?? "", user.address ?? "", user.gender ?? "",uiimage ?? UIImage())
        startLoading("")
        ProfileManager().updateProfile(params, successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let profileResponse = response{
                        if profileResponse.success!{
                            AppSettings.sharedSettings.user = profileResponse.data!
                            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil)
                            self?.dismiss(animated: true , completion: nil)
                        }else{
                            self?.alertMessage(message: response?.message?.en ?? "", completionHandler: {
                                self?.dismiss(animated: true , completion: nil)
                            })
                        }
                    }else{
                        self?.alertMessage(message: response?.message?.en ?? "", completionHandler: {
                            self?.dismiss(animated: true , completion: nil)
                        })
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                    self?.dismiss(animated: true , completion: nil)
                })
            }
        }
    }
}
