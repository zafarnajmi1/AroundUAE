//
//  VCAddTradeLicence.swift
//  Arounduaetest
//
//  Created by Apple on 4/18/19.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

class VCAddTradeLicence: UIViewController {

    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var Attachimage  : UIImage!
    
    @IBOutlet weak var lbltxtAttach: UILabel!
    @IBOutlet weak var lblTradLicence: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var btnAddNow : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
        self.navigationController?.isNavigationBarHidden = false
      self.txtField.layer.borderWidth = 0.5
      self.txtField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.btnAddNow.layer.cornerRadius = 5
        self.btnAttach.layer.cornerRadius = 5
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtField.placeholder = "Attach Photo".localized
        if(lang == "ar")
        {
            self.showArabicBackButton()
            self.txtField.textAlignment = .right
            
        }else if(lang == "en")
        {
            self.addBackButton()
            self.txtField.textAlignment = .left
            
        }
    }
    
    @IBAction func btnAttachAction(_ sender: UIButton) {
        
        picImage()
        
    }
    
    @IBAction func BtnAddNowAction(_ sender: UIButton) {
        if checkImage(){
        AddLicenceAttachment()
        }
    }
    
    func checkImage() -> Bool{
        if((self.Attachimage) == nil)
        {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Upload Your  License".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    private func AddLicenceAttachment(){
        
        let params = (self.Attachimage)
        startLoading("")
        ProfileManager().Addlicence( tradeLicense: self.Attachimage, successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let profileResponse = response{
                        if profileResponse.success!{
                            AppSettings.sharedSettings.user = profileResponse.data!
                             UIApplication.shared.keyWindow?.makeToast("Your lincese is uploaded. Wait for approval and login again".localized)
                            self?.navigationController?.popViewController(animated: true)

//                            self?.dismiss(animated: true , completion: nil)
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
    
    
    
    
    private func picImage(){
        let alert = UIAlertController(title: "Attach Licence Photo".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo".localized, style: .default) {
            UIAlertAction in self.openCamera()
        }
        
        let libraryAction = UIAlertAction(title: "Choose Photo".localized, style: .default) { (action) in
            self.openGallery()
        }
        
        //        let pictureAction = UIAlertAction(title: "Remove Profile Picture".localized, style: .default) {
        //            UIAlertAction in self.removeProfilePicture()
        //        }
        //
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) {
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
    
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    

}
extension VCAddTradeLicence: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.txtField.text = "Root/image.../".localized
            Attachimage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
