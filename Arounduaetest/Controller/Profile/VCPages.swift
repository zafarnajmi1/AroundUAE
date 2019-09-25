//
//  VCPages.swift
//  Arounduaetest
//
//  Created by mohsin raza on 30/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
class VCPages: UIViewController {

    @IBOutlet var lblAboutUs: UILabel!
    @IBOutlet var titlepage: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let shareduserinfo = SharedData.sharedUserInfo
    var titletxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "en"{
            if titletxt == "Terms and Conditions".localized{
                let attributedString = NSMutableAttributedString(string: shareduserinfo.pages[0].detail?.en ?? "")
                lblAboutUs.attributedText = attributedString
            }else{
                let attributedString = NSMutableAttributedString(string: shareduserinfo.pages[1].detail?.en ?? "")
                lblAboutUs.attributedText = attributedString
            }
        }else{
            if titletxt == "Terms and Conditions".localized{
                let attributedString = NSMutableAttributedString(string: shareduserinfo.pages[0].detail?.ar ?? "")
                lblAboutUs.attributedText = attributedString
            }else{
                let attributedString = NSMutableAttributedString(string: shareduserinfo.pages[1].detail?.ar ?? "")
                lblAboutUs.attributedText = attributedString
            }
        }
        
        titlepage.text = titletxt
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = titletxt.localized
        self.setNavigationBar()
        if lang == "ar"{
            self.showArabicBackButton()
        }else{
           self.addBackButton()
        }
    }
}
