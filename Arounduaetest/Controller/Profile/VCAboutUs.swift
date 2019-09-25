//
//  VCAboutUs.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class VCAboutUs: UIViewController {

    @IBOutlet var UIButtonTwitter: UIButton!
    @IBOutlet var UIButtonFaceBook: UIButton!
    @IBOutlet var UIButtonIn: UIButton!
    @IBOutlet var lblAboutUs: UILabel!
    @IBOutlet var aboutustitle: UILabel!
    @IBOutlet var followus: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        UIButtonIn.makeRound()
        UIButtonFaceBook.makeRound()
        UIButtonTwitter.makeRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if lang == "en"{
            let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.en ?? "")
            lblAboutUs.attributedText = attributedString
        }else{
            let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.ar ?? "")
            lblAboutUs.attributedText = attributedString
        }
        
        aboutustitle.text = "Around UAE".localized
        followus.text = "Follow Us".localized
        self.title = "About Us".localized
        
        self.setNavigationBar()
        if lang == "ar"{
            self.showArabicBackButton()
        }else{
            self.addBackButton()
        }
    }
    
    
    @IBAction func openTwiiter(_ sender: UIButton) {
        guard let url = URL(string: shareduserinfo.setting.twitter ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func openFacebook(_ sender: UIButton) {
        guard let url = URL(string: shareduserinfo.setting.facebook ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func openLinkdin(_ sender: UIButton) {
        guard let url = URL(string: shareduserinfo.setting.linkedin ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func share(_ sender:UIButton){
        let text = ""
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
