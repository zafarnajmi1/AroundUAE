//
//  VCRegister.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import DLRadioButton
import Photos
import NKVPhonePicker
import GooglePlaces
import CountryPicker
import FlagKit

class VCRegister: BaseController{
    
    @IBOutlet weak var btncheckuncheck: UIButton!
    @IBOutlet weak var btnIAcceptConditions: UIButton!
    @IBOutlet weak var btnRead: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: NKVPhonePickerTextField!
    
    @IBOutlet weak var txtPasspord: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var countryPicker: CountryPicker!
    @IBOutlet weak var countryPickerMainView: UIView!
    @IBOutlet weak var nicImageText: UILabel!
    @IBOutlet weak var txtAttachNIC: UIButton!{
        didSet{
           txtAttachNIC.titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    @IBOutlet weak var lblGenderText: UILabel!
    @IBOutlet weak var radioMale: DLRadioButton!
    @IBOutlet weak var radioFemale: DLRadioButton!
    @IBOutlet weak var btnRegister: UIButtonMain!
    @IBOutlet weak var lblAlreadyHaveAnAccount: UILabel!
    @IBOutlet weak var btnLoginNow: UIButton!
    @IBOutlet weak var subScrollView: UIView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var imgNic: UIImage?
    let fileName = "Nic_pic"
    var code = "AE"
    var image:UIImage!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        radioMale.isSelected = true
        nicImageText.text = "Attach NIC Copy"
        
        if(lang == "en"){
            self.txtAttachNIC.titleLabel?.textAlignment = .left
        } else if(lang == "ar"){
            self.txtAttachNIC.titleLabel?.textAlignment = .right
        }
        
        txtPhoneNumber.phonePickerDelegate = self
        txtPhoneNumber.favoriteCountriesLocaleIdentifiers = ["AE"]
        txtPhoneNumber.enablePlusPrefix = false
        
        let country = Country.country(for: NKVSource(countryCode: "AE"))
        txtPhoneNumber.country = country
        txtAddress.delegate = self
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
         self.setNavigationBar()
         self.txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone No", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtPasspord.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
         self.txtAddress.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
        self.setupLocalization()
    }
    
    fileprivate func addButton(){
        if(lang == "en"){
            self.txtPhoneNumber.textAlignment = .left
        }else if(lang == "ar"){
            self.txtPhoneNumber.textAlignment = .right
        }
    }
    
    private func setupLocalization(){
        self.title = "Register".localized
        
//        self.txtFirstName.setPadding(left: 10, right: 0)
//        self.txtLastName.setPadding(left: 10, right: 0)
//        self.txtEmail.setPadding(left: 10, right: 0)
//        self.txtPhoneNumber.setPadding(left: 10, right: 0)
//        self.txtPasspord.setPadding(left: 10, right: 0)
//        self.txtConfirmPassword.setPadding(left: 10, right: 0)
//        self.txtAddress.setPadding(left: 10, right: 0)
        
        
        self.lblGenderText.text = "Gender".localized
        self.radioMale.setTitle("Male".localized, for: .normal)
        self.radioFemale.setTitle("Female".localized, for: .normal)
        self.btnRegister.setTitle("Register".localized, for: .normal)
        self.lblAlreadyHaveAnAccount.text = "Already have an account?".localized
        self.btnLoginNow.setTitle("Login now".localized, for: .normal)
        
        
        self.txtAddress.placeholder = "Address".localized
        self.txtLastName.placeholder = "Last Name".localized
        self.txtPhoneNumber.placeholder = "Phone no".localized
        self.txtFirstName.placeholder = "First Name".localized
        //self.nicImageText.text = "Attach NIC Copy".localized
        self.txtConfirmPassword.placeholder = "Confirm Password".localized
        self.txtPasspord.placeholder = "Password".localized
        self.txtEmail.placeholder = "Email".localized
        
        
        if(lang == "ar")
        {
            self.showArabicBackButton()
            self.txtAddress.textAlignment = .right
            self.txtLastName.textAlignment = .right
            self.txtPhoneNumber.textAlignment = .right
            self.txtFirstName.textAlignment = .right
            self.txtConfirmPassword.textAlignment = .right
            self.txtPasspord.textAlignment = .right
            self.txtEmail.textAlignment = .right
            
        }else if(lang == "en")
        {
            self.addBackButton()
            self.txtAddress.textAlignment = .left
            self.txtLastName.textAlignment = .left
            self.txtPhoneNumber.textAlignment = .left
            self.txtFirstName.textAlignment = .left
            self.txtConfirmPassword.textAlignment = .left
            self.txtPasspord.textAlignment = .left
            self.txtEmail.textAlignment = .left
            
        }
    }
    
    @IBAction func attachNic(_ sender: UIButton) {
        picNicImage()
    }
    
    private func picNicImage(){
        let alert = UIAlertController(title: "Nic Picture".localized, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) {
            UIAlertAction in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Library".localized, style: .default) { (action) in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) {
            UIAlertAction in
            self.cancel()
            self.imgNic = nil
            self.nicImageText.text = "Attach NIC Copy".localized
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = false
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Camera not Available".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("Not Available")
        }
    }
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    

    private func isCheck()->Bool{
        
        guard let firstName = txtFirstName.text, firstName.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter First Name".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let lastName = txtLastName.text, lastName.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Last Name".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = txtEmail.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Email".localized, okAction: {
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
        
        guard let phoneNumber = txtPhoneNumber.text, phoneNumber.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Phone Number".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !phoneNumber.isPhoneNumber{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid Phone Number".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let password = txtPasspord.text, password.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Password Below 6 Characters".localized, okAction: {
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
        
        if(password != confirmpassword) {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password do not matched".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let address = txtAddress.text, address.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Address".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let _ = imgNic else{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Select Nic Image".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if btncheckuncheck.isSelected == false{
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please select terms and condition".localized, okAction: {
                
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func btnRegisterClick(_ sender: Any){
        let gender = (radioMale.isSelected) ? "male" : "female"
        if isCheck(){
            self.register(userfullname: txtFirstName.text!+txtLastName.text!, useremail: txtEmail.text!,
            userphone: txtPhoneNumber.text!, userpassword: txtPasspord.text!,
            userpasswordConfirm: txtConfirmPassword.text!, useraddresss: txtAddress.text!,
            userImage: imgNic!, usergender: gender, usernic: Data())
        }
    }
    
    
    @IBAction func btncheckuncheckaction(_ sender: UIButton) {
        if btncheckuncheck.isSelected == false{
            btncheckuncheck.isSelected = true
            btncheckuncheck.setImage(UIImage(named:"Checked-1"), for: UIControl.State.normal)
        }else{
            btncheckuncheck.isSelected = false
            btncheckuncheck.setImage(UIImage(named:"checkbox"), for: UIControl.State.normal)
        }
        
    }
    
    @IBAction func btnReadAction(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.projects.mytechnology.ae/around-uae/pages?slug=terms-%26-conditions"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)//openURL(url)
        }
    }
    
    
    
    
    
    @IBAction func btnLoginNowClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func register(userfullname:String, useremail:String,
        userphone: String, userpassword:String, userpasswordConfirm:String,
        useraddresss:String, userImage: UIImage, usergender:String, usernic: Data){
          startLoading("")
          let params = (userfullname,useremail, userphone,userpassword,userpasswordConfirm,useraddresss,usernic,usergender,"true")
          AuthManager().registerUser(params,userImage: userImage,
          successCallback:
          {[weak self](response) in
             DispatchQueue.main.async {
                self?.finishLoading()
                
                if let Response = response{
                    if(Response.success ?? false == true){
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.moveToVerificationCode()
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "",completionHandler: nil)
                 }
              }
          })
          {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message,completionHandler: nil)
              }
          }
     }
    
    private func moveToVerificationCode(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCEmailVerfication") as! VCEmailVerfication
        vc.email = txtEmail.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCRegister: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imgNic = info[UIImagePickerControllerOriginalImage] as? UIImage
        let diceRoll = Int(arc4random_uniform(678) + 1)
        let a = String(diceRoll)
        self.nicImageText.text = "Pic_" + a + ".jpg"
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension VCRegister: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtAddress {
            let autoComplete = GMSAutocompleteViewController()
            autoComplete.delegate = self
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8678156137, green: 0.2703827024, blue: 0.368032515, alpha: 1)
            UINavigationBar.appearance().tintColor = UIColor.white
            present(autoComplete, animated: true, completion: nil)
        }
    }
}

extension VCRegister: GMSAutocompleteViewControllerDelegate {
   
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
        txtAddress.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
