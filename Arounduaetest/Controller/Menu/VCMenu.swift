//
//  VCMenu.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKLoginKit
import GoogleSignIn

class VCMenu: BaseController, UITableViewDataSource,UITableViewDelegate,CustomHeaderDelegate {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    func didTapButton(in section: Int) {
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProfile") as! VCProfile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet var profileTableView: UITableView!
   
    var Menuimgbuyer = [
        "Orders",
        "Settings",
        "password-1",
        "Contact",
        "AboutUs",
        "Globe"]
    
    var lblMenuNamebuyer = [
       "My Orders".localized,
       "Change Settings".localized,
       "Change Password".localized,
       "Contact Us".localized,
       "About Us".localized,
       "Language".localized]
    
    var Menuimgseller = [ 
        "Cart",
        "Orders",
        "Settings",
        "Selfie",
        "Contact",
        "AboutUs",
        "Globe"]
    
    var lblMenuNameseller = [
        "Manage Products".localized,
        "My Orders".localized,
        "Manage About Page".localized,
        "Review Selfies/Videos".localized,
        "Contact Us".localized,
        "About Us".localized,
        "Language".localized]
    
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if(lang == "en"){
            if AppSettings.sharedSettings.accountType == "seller"{
                lblMenuNameseller += shareduserinfo.pages.map({$0.title?.en ?? ""})
                Menuimgseller += shareduserinfo.pages.map({$0.icon ?? ""})
                profileTableView.reloadData()
                
            }else{
                lblMenuNamebuyer += shareduserinfo.pages.map({$0.title?.en ?? ""})
                Menuimgbuyer += shareduserinfo.pages.map({$0.icon ?? ""})
            }
        }
        else if(lang == "ar"){
            if AppSettings.sharedSettings.accountType == "seller"{
                lblMenuNameseller += shareduserinfo.pages.map({$0.title?.ar ?? ""})
                Menuimgseller += shareduserinfo.pages.map({$0.icon ?? ""})
                profileTableView.reloadData()
                
            }else{
                lblMenuNamebuyer += shareduserinfo.pages.map({$0.title?.ar ?? ""})
                Menuimgbuyer += shareduserinfo.pages.map({$0.icon ?? ""})
            }
        }
        
        lblMenuNameseller.append("Logout".localized)
        Menuimgseller.append("Logout")
        lblMenuNameseller.append("Share Around UAE".localized)
        Menuimgseller.append("social-share-symbol")
        
        lblMenuNamebuyer.append("Logout".localized)
        Menuimgbuyer.append("Logout")
        lblMenuNamebuyer.append("Share Around UAE".localized)
        Menuimgbuyer.append("social-share-symbol")
        
        profileTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar()
        profileTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)?.first as! CustomHeader
        headerView.lblUserProfileMail.text = AppSettings.sharedSettings.user.email!
        headerView.lblUserProfilename.text = AppSettings.sharedSettings.user.fullName!
        headerView.imgUserProfile.sd_setShowActivityIndicatorView(true)
        headerView.imgUserProfile.sd_setIndicatorStyle(.gray)
        headerView.imgUserProfile.sd_setImage(with: URL(string: AppSettings.sharedSettings.user.image ?? ""))
        headerView.sectionNumber = section
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AppSettings.sharedSettings.accountType == "seller"{
            return 0
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppSettings.sharedSettings.accountType == "seller"{
            return Menuimgseller.count
        }else{
            return Menuimgbuyer.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenu") as! CellMenu
        if AppSettings.sharedSettings.accountType == "seller"{
            cell.setupMenu(lblMenuNameseller[indexPath.row], imagestr: Menuimgseller[indexPath.row])
        }else{
            cell.setupMenu(lblMenuNamebuyer[indexPath.row], imagestr: Menuimgbuyer[indexPath.row])
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if AppSettings.sharedSettings.accountType == "seller"{
            let index = indexPath.row
            switch index {
            case 0:
                moveToManagePoduct()
            case 1:
                moveToOrderStores()
            case 2:
                moveToManageAboutPage()
            case 3:
                moveToReviewSelfies()
            case 4:
                moveToContactUs()
            case 5:
                moveToAboutUS()
            case 6:
               moveToSelectLanguage()
            case 7:
               moveTopage(txt: "Terms and Conditions".localized)
            case 8:
               moveTopage(txt: "Privacy Policy".localized)
            case 9:
                self.logOut()
            case 10:
                self.ShareApp()
            default:
                return
            }
        }else{
            let index = indexPath.row
            switch index {
            case 0:
                moveToOrderVC()
            case 1:
                moveToChangeSetting()
            case 2:
                moveToChangePassword()
            case 3:
                moveToContactUs()
            case 4:
                moveToAboutUS()
            case 5:
                moveToSelectLanguage()
            case 6:
                moveTopage(txt: "Terms and Conditions".localized)
            case 7:
                moveTopage(txt: "Privacy Policy".localized)
            case 8:
                self.logOut()
            case 9:
                self.ShareApp()
            default:
                return
            }
        }
    }
    
    private func ShareApp(){
        let text = "http://216.200.116.25/around-uae/"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func moveToReviewSelfies(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderStore") as! VCOrderStore
        vc.ordertype = OrderType.SelfieReview
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToManageAboutPage(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderStore") as! VCOrderStore
        vc.ordertype = OrderType.manageaboutpage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToManagePoduct(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderStore") as! VCOrderStore
        vc.ordertype = OrderType.manageproduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToChangePassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCChangePassword") as! VCChangePassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToChangeSetting(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCChangeSetting") as! VCChangeSetting
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToContactUs(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCContactUs") as! VCContactUs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToSelectLanguage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCSelectLanguage") as! VCSelectLanguage
        vc.isFromMenu = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func moveToAboutUS(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCAboutUs") as! VCAboutUs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveTopage(txt:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPages") as! VCPages
        vc.titletxt = txt
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToOrderVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCMyOrders") as! VCMyOrders
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToOrderStores(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderStore") as! VCOrderStore
        vc.ordertype = OrderType.myorder
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logOut(){
        if let type = AppSettings.sharedSettings.loginMethod{
            if type == "facebook"{
                FBSDKLoginManager().logOut()
                AppSettings.sharedSettings.socialAccessToken = nil
                AppSettings.sharedSettings.socialId = nil
            }else if type == "google"{
                GIDSignIn.sharedInstance().signOut()
                AppSettings.sharedSettings.socialAccessToken = nil
                AppSettings.sharedSettings.socialId = nil
            }
        }
        AppSettings.sharedSettings.userEmail = nil
        AppSettings.sharedSettings.userPassword = nil
        AppSettings.sharedSettings.isAutoLogin = false
        AppSettings.sharedSettings.loginMethod = nil
        self.appDelegate.moveToLogin()
     }
}


