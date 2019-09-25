//
//  VCSelectLanguage.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCSelectLanguage: UIViewController {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var gifimage: UIImageView!
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var lblSelctlanguageContinue: UILabel!
    @IBOutlet weak var btnEnglish: UIButtonMain!
    @IBOutlet weak var btnArabic: UIButtonMain!
    var isFromMenu = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //self.gifimage.loadGif(name: "Gif-3")
         self.gifimage.loadGif(name: "gif1")
        if isFromMenu{
            if lang == "en"{
               addBackButton()
            }else{
               showArabicBackButton()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
    
        self.title = "Language".localized
        self.lblSelectLanguage.text = "Select Language".localized
        self.lblSelctlanguageContinue.text = "Select Language to continue with".localized
        self.btnEnglish.setTitle("English".localized, for: .normal)
        self.btnArabic.setTitle("عربى".localized, for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func btnEnglishClick(_ sender: Any){
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        if AppSettings.sharedSettings.isAutoLogin ?? false{
           appDelegate.moveToHome()
        }else{
           moveToLogin()
        }
    }
    
    @IBAction func btnArabicClick(_ sender: Any){
        UserDefaults.standard.set("ar", forKey: "i18n_language")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        moveToLogin()
    }
    
    func moveToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

