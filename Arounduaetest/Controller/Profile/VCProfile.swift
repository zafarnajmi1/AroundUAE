//
//  VCProfile.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import MBProgressHUD
import GooglePlaces

class VCProfile: BaseController {

    @IBOutlet var imgProfilePicture: UIImageView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtPhoneno: UILabel!
    @IBOutlet weak var scrollSubView: UIView!
    @IBOutlet weak var cnicImage: UIImageView!
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var cniclbl: UILabel!
    @IBOutlet weak var genderlbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var phonenolbl: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var isUpdateProfile = false
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfilePicture.makeRound()
        getUserProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ProfileUpdated"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        if lang == "en"{
            self.addBackButton()
        }else{
            showArabicBackButton()
        }
        
        namelbl.text = "Name:".localized
        emaillbl.text = "Email:".localized
        cniclbl.text = "CNIC:".localized
        genderlbl.text = "Gender:".localized
        citylbl.text = "City:".localized
        addresslbl.text = "Address:".localized
        phonenolbl.text = "Phone no:".localized

        self.title = "Profile".localized
        self.setupUserInfo(AppSettings.sharedSettings.user)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        setupUserInfo(AppSettings.sharedSettings.user)
    }

    private func getUserProfile(){
        startLoading("")
        ProfileManager().getUserProfile(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let profileResponse = response{
                    if profileResponse.success!{
                        AppSettings.sharedSettings.user = profileResponse.data!
                        self?.setupUserInfo(profileResponse.data!)
                        self?.scrollSubView.isHidden = false
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? profileResponse.message?.en ?? "" : profileResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                   self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func uploadImage(_ img:UIImage){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.annularDeterminate
        hud.label.text = "Uploading..."

        ProfileManager().uploadImage(img,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                if let uploadResponse = response{
                    if uploadResponse.success!{
                        AppSettings.sharedSettings.user = uploadResponse.data!
                        NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil)
                        self?.imgProfilePicture.image = nil
                        self?.imgProfilePicture.sd_setShowActivityIndicatorView(true)
                        self?.imgProfilePicture.sd_setIndicatorStyle(.gray)
                        self?.imgProfilePicture.sd_setImage(with: URL(string: uploadResponse.data!.image ?? ""))
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? uploadResponse.message?.en ?? "" : uploadResponse.message?.ar ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? uploadResponse.message?.en ?? "" : uploadResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        },
        failureCallback:
        {[weak self](error) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }){(progress) in
            hud.progress = Float(progress)
        }
    }
    
    private func removeProfilePicture(){
        startLoading("")
        ProfileManager().removeImage(successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let profileResponse = response{
                        if profileResponse.success!{
                            AppSettings.sharedSettings.user = profileResponse.data!
                            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil)
                            self?.imgProfilePicture.image = nil
                            self?.imgProfilePicture.sd_setShowActivityIndicatorView(true)
                            self?.imgProfilePicture.sd_setIndicatorStyle(.gray)
                            self?.imgProfilePicture.sd_setImage(with: URL(string: profileResponse.data!.image ?? ""))
                            
                            
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? profileResponse.message?.en ?? "" : profileResponse.message?.ar ?? "", completionHandler: nil)
                            self?.setupUserInfo(profileResponse.data!)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? profileResponse.message?.en ?? "" : profileResponse.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized,completionHandler : nil)
            }
        }
    }
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        isUpdateProfile = false
        picImage()
    }
    
    @IBAction func updateProfileBtnTap(_ sender: UIButton) {
        isUpdateProfile = true
        picImage()
    }
    
    @IBAction func editTap(_ sender: UIButton) {
        var valueTuple = ("","","")
        switch sender.tag {
            case 1:
            valueTuple = ("Name","Edit Name".localized,"Please Enter your name".localized)
            case 2:
            valueTuple = ("Email","Edit Email".localized,"Please Enter your Email".localized)
            case 5:
            valueTuple = ("1","","")
            case 6:
            valueTuple = ("City","Edit City".localized,"Please Enter your city".localized)
            case 7:
            valueTuple = ("2","","")
            case 8:
            valueTuple = ("PhoneNo","Edit Phone no".localized,"Please Enter your Phone no".localized)
        default:
            break
        }
        if valueTuple.0 == "1"{
            self.performSegue(withIdentifier: "movetogender", sender: AppSettings.sharedSettings.user.gender!)
        }else if valueTuple.0 == "2"{
            let autoComplete = GMSAutocompleteViewController()
            autoComplete.delegate = self
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8678156137, green: 0.2703827024, blue: 0.368032515, alpha: 1)
            UINavigationBar.appearance().tintColor = UIColor.white
            present(autoComplete, animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "movetopopover", sender: valueTuple)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movetopopover"{
            let dvc = segue.destination as! VCPopUpprofile
            let value = sender as! (String,String,String)
            dvc.headertxt = value.1
            dvc.titlefield = value.2
            dvc.placeholdertxt = value.0
        }else if segue.identifier == "movetogender"{
            let dvc = segue.destination as! VCEditGender
            let value = sender as! String
            dvc.gender = value
        }
    }
    
    private func setupUserInfo(_ userInfo:User){
         imgProfilePicture.sd_setShowActivityIndicatorView(true)
         imgProfilePicture.sd_setIndicatorStyle(.gray)
         imgProfilePicture.sd_setImage(with: URL(string: AppSettings.sharedSettings.user.image ?? ""))
         txtUserName.text = AppSettings.sharedSettings.user.fullName
         txtEmail.text = AppSettings.sharedSettings.user.email
         cnicImage.sd_setShowActivityIndicatorView(true)
         cnicImage.sd_setIndicatorStyle(.gray)
         cnicImage.sd_setImage(with: URL(string: AppSettings.sharedSettings.user.nic ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
         txtGender.text = AppSettings.sharedSettings.user.gender
         txtCity.text = AppSettings.sharedSettings.user.address
         txtAddress.text = AppSettings.sharedSettings.user.address
         txtPhoneno.text = AppSettings.sharedSettings.user.phone
    }
    
    private func picImage(){
        let alert = UIAlertController(title: "Profile Picture".localized, message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) {
            UIAlertAction in self.openCamera()
        }
        
        let libraryAction = UIAlertAction(title: "Library".localized, style: .default) { (action) in
            self.openGallery()
        }
        
//        let pictureAction = UIAlertAction(title: "Remove Profile Picture".localized, style: .default) {
//            UIAlertAction in self.removeProfilePicture()
//        }
//
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        //alert.addAction(pictureAction)
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
    
    private func updateProfile(_ user:User){
        
        let params = (user.fullName ?? "",user.email ?? "",user.phone ?? "",user.address ?? "",user.gender ?? "",cnicImage.image ?? UIImage())
        startLoading("")
        ProfileManager().updateProfile(params, successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let profileResponse = response{
                        if profileResponse.success!{
                            AppSettings.sharedSettings.user = profileResponse.data!
                            self?.setupUserInfo(profileResponse.data!)
                            self?.dismiss(animated: true , completion: nil)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? profileResponse.message?.en ?? "" : profileResponse.message?.ar ?? "", completionHandler: {
                                self?.dismiss(animated: true , completion: nil)
                            })
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
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
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    private func moveToChangePassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCChangePassword") as! VCChangePassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ProfileUpdated"), object: nil)
    }
}

extension VCProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if isUpdateProfile{
                cnicImage.image = image
                updateProfile(AppSettings.sharedSettings.user)
            }else{
                uploadImage(image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension VCProfile: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtAddress.text = place.name
        AppSettings.sharedSettings.user.address = place.name
        updateProfile(AppSettings.sharedSettings.user)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

