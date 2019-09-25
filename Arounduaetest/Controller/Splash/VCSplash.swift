//
//  VCSplash.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
let currency = UserDefaults.standard.string(forKey: "currency")
class VCSplash: BaseController,CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    @IBOutlet weak var slpashGif: UIImageView!
    @IBOutlet weak var lblSplashScreen: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    var isVarified = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var User = SharedData.sharedUserInfo
    let defaults = UserDefaults.standard
    var fcmToken = "0"
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gif1
        //self.slpashGif.loadGif(name: "Gif-3")
        self.slpashGif.loadGif(name: "gif1")
        //imageview.sd_setImage(with: URL(string: "http://216.200.116.25/around-uae/site/test_image"), placeholderImage: #imageLiteral(resourceName: "Category"))
        if(currency == nil){
            UserDefaults.standard.set("usd", forKey: "currency")
            
        }
        
        currentCordinate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.loadSettingData()
        if lang == "ar"{
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else if lang == "en"{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        lblSplashScreen.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's".localized
    }
    
    
    func currentCordinate()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()//requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("Location Manager Result arrived")
        
        let location = locations.last! as CLLocation
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
        SharedData.sharedUserInfo.lat = location.coordinate.latitude
        SharedData.sharedUserInfo.long = location.coordinate.longitude
        
        print(SharedData.sharedUserInfo.lat)
    }
    
    
    
    
    private func loadSettingData(){
        startLoading("")
        IndexManager().getSiteSettings(successCallback:
        {[weak self](response) in
                self?.finishLoading()
                if let settingResposne = response{
                    if(settingResposne.success!){
                        self?.User.index = settingResposne.data!
                        self?.User.setting = (settingResposne.data?.settings!)!
                        self?.User.pages = (settingResposne.data?.pages!)!
                        self?.User.sliders = (settingResposne.data?.sliders!)!
                        self?.goToNext()
                    }else{
                        self?.showAlert((self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", tryAgainClouser: {_ in self?.loadSettingData()})
                    }
                }else{
                    self?.showAlert((self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", tryAgainClouser: {_ in self?.loadSettingData()})
                }
        }){[weak self](error) in
                self?.finishLoading()
                self?.showAlert(error.message, tryAgainClouser:
                {_ in self?.loadSettingData()})
           }
       }
    
    private func goToNext(){
        if lang == nil{
           UserDefaults.standard.set("en", forKey: "i18n_language")
           self.appDelegate.moveToSelectlanguage()
        }else{
            if let autologin = AppSettings.sharedSettings.isAutoLogin, autologin == true {
                if let value = AppSettings.sharedSettings.loginMethod{
                    if value == "local"{
                        logInFromEmail()
                    }else if value == "google"{
                        checkIsSocialLogin(check: 0)
                    }else if value == "facebook"{
                        checkIsSocialLogin(check: 1)
                    }else{
                       self.appDelegate.moveToLogin()
                    }
                }
            }else{
                self.appDelegate.moveToLogin()
            }
        }
    }
    
     private func logInFromEmail(){
        startLoading("")
        
        if let userpassword = AppSettings.sharedSettings.userPassword,
           let useremail = AppSettings.sharedSettings.userEmail{
    
            AuthManager().loginUser((useremail,userpassword),
            successCallback:
            {[weak self](response) in
                self?.finishLoading()
                
                if let loginResponse = response{
                    if(loginResponse.success!){
                        
//                        AppSettings.sharedSettings.user = loginResponse.data!
//                        let accountType = loginResponse.data?.accountType!
//                        let authToken = loginResponse.data?.authorization!
//                        AppSettings.sharedSettings.authToken = authToken
//                        AppSettings.sharedSettings.loginMethod = "local"
//                        AppSettings.sharedSettings.accountType = accountType
//                        self?.appDelegate.moveToHome()
                        
                        if(loginResponse.data?.accountType == "seller"){
                            if(loginResponse.data?.isEmailVerified ==  true){

                                    AppSettings.sharedSettings.user = loginResponse.data!
                                    let accountType = loginResponse.data?.accountType!
                                    let authToken = loginResponse.data?.authorization!
                                    AppSettings.sharedSettings.authToken = authToken
                                    AppSettings.sharedSettings.loginMethod = "local"
                                    AppSettings.sharedSettings.accountType = accountType

                                    if(loginResponse.data?.isTradeLiceseAccepted == true){
                                        self?.appDelegate.moveToHome()
                                     }else
                                     {
//                                        UIApplication.shared.keyWindow?.makeToast("Your license is not accepted yet. Wait for approval and login again".localized)
                                        self?.appDelegate.moveToLogin()
                                        
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let vc = storyboard.instantiateViewController(withIdentifier: "VCAddTradeLicence") as! VCAddTradeLicence
//                                        self?.navigationController?.pushViewController(vc, animated: true)

                                      }
                                
                            }else{
                                 

                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "VCEmailVerfication") as! VCEmailVerfication
                                self!.navigationController?.pushViewController(vc, animated: true)

                             }
                            
                        }else
                        {
                            AppSettings.sharedSettings.user = loginResponse.data!
                            let accountType = loginResponse.data?.accountType!
                            let authToken = loginResponse.data?.authorization!
                            AppSettings.sharedSettings.authToken = authToken
                            AppSettings.sharedSettings.loginMethod = "local"
                            AppSettings.sharedSettings.accountType = accountType
                            self?.appDelegate.moveToHome()
                            
                            
                        }
                        
                        
                        
                        
                    
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.appDelegate.moveToLogin()
                        })
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: {
                        self?.logInFromEmail()
                    })
                 }
            },failureCallback:
               {[weak self](error) in
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                    self?.logInFromEmail()
                })
            })
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func checkIsSocialLogin(check: Int){
        
        guard let id = AppSettings.sharedSettings.socialId, let acesstoken = AppSettings.sharedSettings.socialAccessToken,
            let email = AppSettings.sharedSettings.userEmail, let name = AppSettings.sharedSettings.fullName,
            let authmethod = AppSettings.sharedSettings.loginMethod else{
                return
        }
        let param = (id,acesstoken,email,authmethod,name)
        startLoading("")
        AuthManager().SocialLogin((id,acesstoken,email,authmethod,name),
        successCallback:
        {[weak self](response) in
            self?.finishLoading()
            if let socialResponse = response{
                if(socialResponse.success!){
                    self?.userProfileData(check : check, params: param, successResponse : socialResponse)
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                        self?.checkIsSocialLogin(check: check)
                    })
                }
            }else{
                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                    self?.checkIsSocialLogin(check: check)
                })
            }
        })
        {[weak self](error) in
            self?.alertMessage(message: error.message.localized, completionHandler: {
                self?.checkIsSocialLogin(check: check)
            })
        }
    }
    
    private func userProfileData(check : Int, params:SocialParams ,successResponse : Response<User>){
        AppSettings.sharedSettings.user = successResponse.data!
        let accountType = successResponse.data?.accountType!
        let authToken = successResponse.data?.authorization!
        AppSettings.sharedSettings.authToken = authToken
        AppSettings.sharedSettings.accountType = accountType
        AppSettings.sharedSettings.loginMethod = (check == 0) ? "google" : "facebook"
        AppSettings.sharedSettings.socialId = params.id
        AppSettings.sharedSettings.socialAccessToken = params.accessToken
        AppSettings.sharedSettings.userEmail = params.email
        AppSettings.sharedSettings.fullName = params.fullName
        self.appDelegate.moveToHome()
    }
}
