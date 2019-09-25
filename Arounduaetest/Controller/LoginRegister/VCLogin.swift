//
//  VCLogin.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class VCLogin: BaseController {
    
    @IBOutlet weak var gifimagelogin: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var bgColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
    var User = SharedData.sharedUserInfo
    let defaults = UserDefaults.standard
    var ishownBackBtn = true
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet weak var txtEmail: UITextFieldCustom!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButtonMain!
    @IBOutlet weak var btnForgetYourPassword: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblContinueWithFaceBook: UILabel!
    @IBOutlet weak var lblContinueWithGmail: UILabel!
    @IBOutlet weak var lblDontHaveAnAccount: UILabel!
    @IBOutlet weak var btnRegisterNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.gifimagelogin.loadGif(name: "Gif-3")
        self.gifimagelogin.loadGif(name: "gif1")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.TxtFfieldLocalaiz()
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setNavigationBar()
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
        self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.3999774754, green: 0.400015533, blue: 0.3999456167, alpha: 1)])
        self.setupLocalization()
    }
    
    func TxtFfieldLocalaiz()
    {
        let  passwordimg = UIImage(named: "Password")
        let  userimg = UIImage(named: "Username")
        
        if (lang == "ar"){
            
            txtEmail.setPadding(left: 0, right: 15)
            txtPassword.setPadding(left: 0, right: 15)
            
            self.txtPassword.withImage(direction: .Right, image: passwordimg!, colorSeparator: bgColor, colorBorder: bgColor)
            self.txtEmail.withImage(direction: .Right, image: userimg!, colorSeparator: bgColor, colorBorder: bgColor)
        } else if(lang == "en")
        {
            
            txtEmail.setPadding(left: 0, right: 0)
            txtPassword.setPadding(left: 0, right: 0)
            self.txtEmail.withImage(direction: .Left, image: userimg!, colorSeparator: bgColor, colorBorder: bgColor)
            self.txtPassword.withImage(direction: .Left, image: passwordimg!, colorSeparator: bgColor, colorBorder: bgColor)
            
        }
    }
    
    private func setupLocalization(){
        self.title = "Login".localized
        self.txtEmail.placeholder = "Email".localized
        self.txtPassword.placeholder = "Password".localized
        self.btnLogin.setTitle("Login".localized, for: .normal)
        self.btnRegisterNow.setTitle("Register now".localized, for: .normal)
        self.btnForgetYourPassword.setTitle("Forgot your password?".localized, for: .normal)
        self.lblOR.text = "OR".localized
        self.lblContinueWithFaceBook.text = "Login with facebook".localized
        self.lblContinueWithGmail.text = "Login with gmail".localized
        self.lblDontHaveAnAccount.text = "Don't have an account?".localized
        
        if (lang == "ar"){
            //self.showArabicBackButton()
            self.txtPassword.textAlignment = .right
            self.txtEmail.textAlignment = .right
        }
        else if(lang == "en"){
            //self.addBackButton()
            self.txtPassword.textAlignment = .left
            self.txtEmail.textAlignment = .left
        }
    }
    
    
    private func isCheck()->Bool{
        
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
        
        guard let password = txtPassword.text, password.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func btnLoginClick(_ sender: Any){
        if isCheck(){
            loginUser(useremail:txtEmail.text!, userpassword:txtPassword.text!)
        }
    }
    
    @IBAction func btnForgetPasswordClick(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCForgotPassword") as! VCForgotPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFacebookClick(_ sender: Any){
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self)
        {[weak self](result, error) in
            if error != nil{
                print(error?.localizedDescription ?? "Nothing")
            }else if (result?.isCancelled)!{
                print("Cancel")
            }
            else{
                if(result?.grantedPermissions.contains("email"))!{
                     self?.logInFromFacebook()
                }
            }
        }
    }
    
    @IBAction func btnGoogleClick(_ sender: Any){
        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn?.shouldFetchBasicProfile = true
        googleSignIn?.scopes = ["profile", "email"]
        googleSignIn?.delegate = self
        googleSignIn?.signIn()
    }
    
    @IBAction func btnRegisterNowClick(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCRegister") as! VCRegister
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginUser(useremail:String,userpassword:String){
        startLoading("")
        AuthManager().loginUser((useremail,userpassword),
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let loginResponse = response{
                        
                        if(loginResponse.success!){
                            
                            AppSettings.sharedSettings.user = loginResponse.data!
                            let accountType =  loginResponse.data?.accountType ?? ""
                            let authToken  = loginResponse.data?.authorization ?? ""
                            AppSettings.sharedSettings.authToken = authToken
                            AppSettings.sharedSettings.accountType = accountType
                            
//                            if(loginResponse.data?.isEmailVerified! == true){
//                                AppSettings.sharedSettings.userEmail = self?.txtEmail.text!
//                                AppSettings.sharedSettings.userPassword = self?.txtPassword.text!
//                                AppSettings.sharedSettings.isAutoLogin = true
//                                AppSettings.sharedSettings.loginMethod = "local"
//                                self?.appDelegate.moveToHome()
//
//                            }else{
//                                self?.moveToVCEmail()
//                            }
                            
                        if(loginResponse.data?.accountType == "seller"){
                            
                            if(loginResponse.data?.isEmailVerified! == true){
                                    AppSettings.sharedSettings.userEmail = self?.txtEmail.text!
                                    AppSettings.sharedSettings.userPassword = self?.txtPassword.text!
                                    AppSettings.sharedSettings.isAutoLogin = true
                                    AppSettings.sharedSettings.loginMethod = "local"
                                if loginResponse.data?.tradeLicense == nil || loginResponse.data?.tradeLicense == "" {
                                    self?.moveToTradeLicence()
                                }
                                else if(loginResponse.data?.isTradeLiceseAccepted == true){
                                          self?.appDelegate.moveToHome()
                                    }else{
                                    
                                    self?.alertMessage(message:  "We received your Trade License. Please wait for approval".localized, completionHandler: nil)
                                    
//                                    self?.moveToTradeLicence()
                                    
                                     }
    
                                }else{
                                        self?.moveToVCEmail()
                                }
                                }else{
                            
                            
                                if(loginResponse.data?.isEmailVerified! == true){
                                    AppSettings.sharedSettings.userEmail = self?.txtEmail.text!
                                    AppSettings.sharedSettings.userPassword = self?.txtPassword.text!
                                    AppSettings.sharedSettings.isAutoLogin = true
                                    AppSettings.sharedSettings.loginMethod = "local"
                                    self?.appDelegate.moveToHome()
    
                                }else{
                                    self?.moveToVCEmail()
                                }
                            
                            }
                            
                            
                            
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            },failureCallback:
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                }
        })
    }
    func moveToTradeLicence(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCAddTradeLicence") as! VCAddTradeLicence
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCLogin: GIDSignInUIDelegate, GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print(error.localizedDescription)
        }
        if error == nil{
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.idToken ?? ""
            SocialLogin(0, socialId: user.userID,accesstoken: accessToken,email: user.profile.email, fullname: user.profile.name,authmethod: "google")
        }
    }
    
    func SocialLogin(_ type:Int,socialId:String,accesstoken:String,email:String,fullname:String,authmethod:String){
        startLoading("")
        let param = (socialId,accesstoken,email,authmethod,fullname)
        AuthManager().SocialLogin(param,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let socialResponse = response{
                    if (socialResponse.success!){
                        self?.userProfileData(check: type, params: param, successResponse: socialResponse)
                    }
                    else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func userProfileData(check : Int, params:SocialParams ,successResponse : Response<User>){
        
        AppSettings.sharedSettings.user = successResponse.data!
        let accountType = successResponse.data?.accountType ?? ""
        let authToken = successResponse.data?.authorization ?? ""
        AppSettings.sharedSettings.authToken = authToken
        AppSettings.sharedSettings.accountType = accountType
        
        if(successResponse.data?.isEmailVerified! == true){
            AppSettings.sharedSettings.isAutoLogin = true
            AppSettings.sharedSettings.loginMethod = (check == 0) ? "google" : "facebook"
            AppSettings.sharedSettings.socialId = params.id
            AppSettings.sharedSettings.socialAccessToken = params.accessToken
            AppSettings.sharedSettings.userEmail = params.email
            AppSettings.sharedSettings.fullName = params.fullName

            self.appDelegate.moveToHome()
        }else{
            self.moveToVCEmail()
        }
    }
    
    private func moveToVCEmail(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCEmailVerfication") as! VCEmailVerfication
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCLogin{
    
    func logInFromFacebook() {
        if (FBSDKAccessToken.current() != nil) {
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                
                if error != nil{
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else{
                    guard let results = result as? NSDictionary else { return }
                    print(results)
                    guard let facebookId = results["id"] as? String,
                        let email = results["email"] as? String,
                        let fullName = results["name"] as? String else {
                            return
                    }
                    let token = FBSDKAccessToken.current().tokenString ?? ""
                    DispatchQueue.main.async {
                        self.SocialLogin(1, socialId: facebookId,accesstoken: token,email: email, fullname: fullName,authmethod: "facebook")
                    }
                }
            }
        }
    }
}
