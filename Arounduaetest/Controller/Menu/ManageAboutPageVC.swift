//
//  ManageAboutPageVC.swift
//  Arounduaetest
//
//  Created by Apple on 31/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage
import UITextView_Placeholder

class ManageAboutPageVC: UIViewController {

    @IBOutlet weak var manageaboutCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var lblEnglishTextField: UITextView!
    @IBOutlet weak var lblArabicTextField: UITextView!
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var storeObject:Stores!
    var galleryArray = [Gallery]()
    var galleryImage:UIImage?
    var isForSelfie = false
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Store About".localized
        setupData()
        addMenuButtons()
        fetchProductInfo(storeObject._id ?? "", isRefresh: false)
    }

    func addMenuButtons(backImage: UIImage = #imageLiteral(resourceName: "Chat-1")) {
        let button =  UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "Takeselfie"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x:0,y:0,width:53,height:31)
        button.imageEdgeInsets = UIEdgeInsetsMake(-1, -32, 1, 32)
        let label = UILabel(frame: CGRect(x:0,y:5,width: 70,height:20))
        label.font = UIFont(name: "Arial", size: 10)
        label.text = "Add Image/Video"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.setRightBarButtonItems([barButton], animated: true)
    }
    
    @objc func buttonAction(){
        isForSelfie = true
        picImage(true)
    }
    
    private func fetchProductInfo(_ storeId: String, isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        SelfieManager().getSelfies(storeId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let productResponse = response{
                        if productResponse.success!{
                            
                            self?.galleryArray = productResponse.data?.gallery ?? []
                            self?.manageaboutCollectionView.reloadData()
                            self?.setCollectionViewHeight()
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationBar()
        if lang == "en"{
            addBackButton()
            lblEnglishTextField.textAlignment = .left
            lblArabicTextField.textAlignment = .left
        }else{
            showArabicBackButton()
            lblEnglishTextField.textAlignment = .right
            lblArabicTextField.textAlignment = .right
        }
        
        lblEnglishTextField.placeholder = "Description(English)"
        lblArabicTextField.placeholder = "Description(Arabic)"
    }
    
    private func setCollectionViewHeight(){
        collectionViewHeightConstraint.constant = manageaboutCollectionView.collectionViewLayout.collectionViewContentSize.height + 10
        self.manageaboutCollectionView.setNeedsDisplay()
    }
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return .zero
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 3
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 5.0
    }
    
    private func setupData(){
        storeImage.sd_setShowActivityIndicatorView(true)
        storeImage.sd_setIndicatorStyle(.gray)
        storeImage.sd_setImage(with: URL(string: storeObject.image ?? ""))
        lblEnglishTextField.text = storeObject.description?.en ?? ""
        lblArabicTextField.text = storeObject.description?.ar ?? ""
    }
    
    @IBAction func editStoreImage(_ sender: UIButton) {
        picImage(false)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func isCheck()->Bool{
        
        guard let englishdescription = lblEnglishTextField.text, englishdescription.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Description For English".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let arabicdescription = lblArabicTextField.text, arabicdescription.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Description For Arabic".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
       
        return true
    }
    
    @IBAction func submit(_ sender: UIButton){
        
        if !isCheck(){
            return
        }
        
        self.startLoading("")
        ProfileManager().aboutPage((lblEnglishTextField.text!,lblArabicTextField.text!,storeImage.image!,storeObject._id ?? ""),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let aboutResponse = response{
                    if aboutResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? aboutResponse.message?.en ?? "" : aboutResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? aboutResponse.message?.en ?? "" : aboutResponse.message?.ar ?? "", completionHandler: {
                             self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                         self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                     self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    private func picImage(_ ForSelfie:Bool){
        if isForSelfie{
            isForSelfie = true
        }else{
            isForSelfie = false
        }
        let alert = UIAlertController(title: "Store Picture".localized, message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) {
            UIAlertAction in
            
            self.openCamera()
        }
        
        let libraryAction = UIAlertAction(title: "Library".localized, style: .default) { (action) in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
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
}

extension ManageAboutPageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if isForSelfie {
              galleryImage = image
              uploadGalleryImage(image)
                
            }else{
              storeImage.image = image
            }
         }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadGalleryImage(_ galleryImage:UIImage){
        
        let profileImageData = UIImageJPEGRepresentation(galleryImage,0.7)!
        startLoading("")
        SelfieManager().uploadGallery((storeObject?._id ?? "",profileImageData,Data()),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                
                if let galleryresponse = response{
                    if galleryresponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.fetchProductInfo(self?.storeObject?._id ?? "", isRefresh: false)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                   self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        },
        failureCallback:
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        })
    }
}

extension  ManageAboutPageVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isvideo = galleryArray[indexPath.row].mimeType
        if isvideo == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoManageCell", for: indexPath) as! VideoManageCell
            cell.videoImage.sd_setShowActivityIndicatorView(true)
            cell.videoImage.sd_setIndicatorStyle(.gray)
            cell.videoImage.sd_setImage(with: URL(string: galleryArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageManageCell", for: indexPath) as! ImageManageCell
            cell.normalImage.sd_setShowActivityIndicatorView(true)
            cell.normalImage.sd_setIndicatorStyle(.gray)
            cell.normalImage.sd_setImage(with: URL(string: galleryArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            cell.delegate = self
            return cell
        }
    }
}

extension ManageAboutPageVC: DeleteGalleryImage{
    func deleteGalleryVideoImage(cell: VideoManageCell) {
        let indexpath = manageaboutCollectionView.indexPath(for: cell)!
        SelfieManager().deleteGallery(storeObject._id ?? "", selfieid: galleryArray[indexpath.row]._id ?? "",
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let deleteResponse = response{
                    if deleteResponse.success!{
                        self?.galleryArray.remove(at: indexpath.row)
                        self?.manageaboutCollectionView.deleteItems(at: [indexpath])
                        self?.fetchProductInfo(self?.storeObject._id ?? "", isRefresh: false)
                    }else{
                       self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
    
    func deleteGalleryNormalImage(cell: ImageManageCell) {
        let indexpath = manageaboutCollectionView.indexPath(for: cell)!
        SelfieManager().deleteGallery(storeObject._id ?? "", selfieid: galleryArray[indexpath.row]._id ?? "",
            successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let deleteResponse = response{
                        if deleteResponse.success!{
                            self?.galleryArray.remove(at: indexpath.row)
                            self?.manageaboutCollectionView.deleteItems(at: [indexpath])
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
}

protocol DeleteGalleryImage{
    func deleteGalleryVideoImage(cell:VideoManageCell)
    func deleteGalleryNormalImage(cell:ImageManageCell)
}


class VideoManageCell:UICollectionViewCell{
    var delegate: DeleteGalleryImage?
    @IBOutlet weak var videoImage:UIImageView!
    @IBAction func deleteVideoImage(_ sender:UIButton){
        self.delegate?.deleteGalleryVideoImage(cell: self)
    }
}

class ImageManageCell:UICollectionViewCell{
    var delegate: DeleteGalleryImage?
    @IBOutlet weak var normalImage:UIImageView!
    @IBAction func deleteVideoImage(_ sender:UIButton){
        self.delegate?.deleteGalleryNormalImage(cell: self)
    }
}
