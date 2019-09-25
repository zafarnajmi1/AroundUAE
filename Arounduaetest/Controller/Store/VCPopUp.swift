//
//  VCPopUp.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Cosmos

class VCPopUp: UIViewController {

    @IBOutlet var lblHowsExperience: UILabel!
    @IBOutlet var lblSubmitFeedBack: UILabel!
    @IBOutlet var textViewWriteComments: UICustomTextView!
    @IBOutlet var btnCancel: UIButtonMain!
    @IBOutlet var btnSubmit: UIButtonMain!
    @IBOutlet weak var ratingView: CosmosView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var placeid:String?
    var productid:String?
    var storeid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewWriteComments.delegate = self
        textViewWriteComments.text = "Comment...".localized
        textViewWriteComments.textColor = UIColor.lightGray
    }
    
    @IBAction func btnAction(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        lblSubmitFeedBack.text = "Submit Feedback".localized
        if let _ = placeid{
            lblHowsExperience.text = "How was your experience with instinct Place?".localized
        }else if let _ = storeid{
            lblHowsExperience.text = "How was your experience with instinct Store?".localized
        }else if let _ = productid{
            lblHowsExperience.text = "How was your experience with instinct Product?".localized
        }
        textViewWriteComments.text = "Write Comments...".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
        if lang == "en"{
            textViewWriteComments.textAlignment = .left
        }else{
            textViewWriteComments.textAlignment = .right
        }
    }
    
    private func isCheckReview()->Bool{
        guard let comment = textViewWriteComments.text,comment != "Comment...".localized else{
            self.alertMessage(message: "Please Enter Your Comment!".localized, completionHandler: nil)
            return false
        }
        return true
    }
    
    @IBAction func submit(_ sender: Any){
        if !isCheckReview(){
            return
        }
        if let _ = placeid{
           placeReview()
        }else if let _ = storeid{
           storeReview()
        }else if let _ = productid{
           productReview()
        }
    }
    
    private func storeReview(){
        startLoading("")
        StoreManager().storeReview((storeid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: {
                             self?.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func placeReview(){
        startLoading("")
        CitiesPlacesManager().submitPlaceReview((placeid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: {
                            self?.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    private func productReview(){
        startLoading("")
        ProductManager().submitProductReview((productid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: {
                            self?.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? reviewResponse.message?.en ?? "" : reviewResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}

extension VCPopUp: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewWriteComments.textColor == UIColor.lightGray {
            textViewWriteComments.text = nil
            textViewWriteComments.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewWriteComments.text.isEmpty {
            textViewWriteComments.text = "Comment...".localized
            textViewWriteComments.textColor = UIColor.lightGray
        }
    }
}
