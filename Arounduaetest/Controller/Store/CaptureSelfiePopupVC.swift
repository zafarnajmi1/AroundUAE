//
//  CaptureSelfiePopupVC.swift
//  Arounduaetest
//
//  Created by Apple on 13/11/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit


class CaptureSelfiePopupVC: UIViewController {
    
    @IBOutlet weak var captureImage_Btn:UIButton!
    @IBOutlet weak var capturevideo_Btn:UIButton!
    
    @IBOutlet weak var cancel_Btn:UIButton!
    @IBOutlet weak var upload_Btn:UIButton!
    
    @IBOutlet weak var selectionView:UIView!
    @IBOutlet weak var captonView:UIView!
    @IBOutlet weak var captonField:UITextField!
    
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var pickedImage:UIImage?
    var videoPath: NSURL? = nil
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var movieData: NSData?
    var videoThumbnail:UIImage?
    var storeid = ""
    var placeid = ""
    var isVideo = false

    override func viewDidLoad() {
        super.viewDidLoad()
        captonField.layer.borderWidth = 0.5
        captonField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        captonField.setLeftPaddingPoints(10)
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
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func captureImage(_ sender:UIButton){
        openCamera()
    }
    
    @IBAction func captureVideo(_ sender:UIButton){
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @IBAction func cancelSelection(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadSelection(_ sender:UIButton){
        
        guard let caption = captonField.text, caption.count > 0 else{
            self.alertMessage(message: "Please Enter Caption", completionHandler: nil)
            return
        }
        
        if isVideo{
            uploadVideoData(caption)
        }else{
            uploadImage(caption)
        }
    }
    
    @IBAction func backgroundtapped(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
}

extension CaptureSelfiePopupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeMovie as String) {
                self.videoPath = info[UIImagePickerControllerMediaURL] as? NSURL
                if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                    let ass = AVAsset(url:videoURL as URL)
                    if let Thumbnail = ass.videoThumbnail{
                        videoThumbnail = Thumbnail
                    }
                }
                isVideo = true
                selectionView.isHidden = true
                captonView.isHidden = false
        }else{
            if let picked = info[UIImagePickerControllerOriginalImage] as? UIImage {
                pickedImage = picked
                isVideo = false
                selectionView.isHidden = true
                captonView.isHidden = false
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadVideoData(_ caption:String){
        
        if storeid != ""{
            do {
                movieData = try NSData(contentsOfFile: (videoPath?.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
                guard let image = videoThumbnail,let imagedata = UIImageJPEGRepresentation(image, 0.7) else {
                    return
                }
                
                startLoading("")
                SelfieManager().storeUploadSelfie((storeid,caption,movieData! as Data,imagedata,"video"),
                                                  successCallback:
                    {[weak self](response) in
                        DispatchQueue.main.async {
                            self?.finishLoading()
                            if let videoResponse = response{
                                if(videoResponse.success!){
                                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                                }else{
                                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                                }
                            }
                        }
                    })
                {[weak self](error) in
                    DispatchQueue.main.async {
                        self?.finishLoading()
                        self?.alertMessage(message: error.message, completionHandler: nil)
                    }
                }
                
            } catch _ {
                movieData = nil
                return
            }
        }else{
            do {
                movieData = try NSData(contentsOfFile: (videoPath?.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
                guard let image = videoThumbnail,let imagedata = UIImageJPEGRepresentation(image, 0.7) else {
                    return
                }
                
                startLoading("")
                SelfieManager().placeUploadSelfie((placeid,caption,movieData! as Data,imagedata,"video"),
                                                  successCallback:
                    {[weak self](response) in
                        DispatchQueue.main.async {
                            self?.finishLoading()
                            if let videoResponse = response{
                                if(videoResponse.success!){
                                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                                }else{
                                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                                }
                            }
                        }
                    })
                {[weak self](error) in
                    DispatchQueue.main.async {
                        self?.finishLoading()
                        self?.alertMessage(message: error.message, completionHandler: nil)
                    }
                }
                
            } catch _ {
                movieData = nil
                return
            }
        }
    }
    
    private func uploadImage(_ caption:String){
        
        guard let image = pickedImage,let imagedata = UIImageJPEGRepresentation(image, 0.7) else {
            return
        }
        
        if storeid != ""{
            startLoading("")
            SelfieManager().storeUploadSelfie((storeid,caption,imagedata,Data(),"image"),
            successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let videoResponse = response{
                        if(videoResponse.success!){
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                self?.dismiss(animated: true, completion: nil)
                            })
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                self?.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                }
            })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.alertMessage(message: error.message, completionHandler: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }else{
            startLoading("")
            SelfieManager().placeUploadSelfie((placeid,caption,imagedata,Data(),"image"),
            successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.finishLoading()
                        if let videoResponse = response{
                            if(videoResponse.success!){
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                    self?.dismiss(animated: true, completion: nil)
                                })
                            }else{
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                    self?.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.alertMessage(message: error.message, completionHandler: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
}
extension AVAsset{
    var videoThumbnail:UIImage?{
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            return thumbNail
            
        } catch {
            return nil
        }
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
