//
//  VCGenralServices.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVFoundation
import AVKit
import SDWebImage

class SelfiVedioVC: BaseController,IndicatorInfoProvider{
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    var checktest : Bool = false
    var selfiArray = [Selfies]()
    var totalPages = 0
    var currentPage = 0
    var storeid = ""
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        fetchProductInfo(storeid, isRefresh: false)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
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
                            self?.selfiArray = productResponse.data?.selfies?.filter({$0.isActive ?? false == true}) ?? []
                            self?.collectionView.reloadData()
                            
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Selfie/Video".localized)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Selfie/Video".localized
       
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
        
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let nc = NotificationCenter.default
//        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let nc = NotificationCenter.default
//        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
//
//        }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserLoggedIn"), object: nil)
//    }
    
    fileprivate func setupDelegates(){
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.collectionView.reloadData()
    }
}

extension SelfiVedioVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selfiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let isvideo = selfiArray[indexPath.row].mimeType

        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if isvideo == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralVideoCell", for: indexPath) as! VCSelfiesCell
            cell.userName.text = selfiArray[indexPath.row].caption ?? ""
            let date = dateFormatter.date(from: selfiArray[indexPath.row].createdAt!)!
            dateFormatter.dateFormat = "d MMM, yyyy"
            dateFormatter.locale = tempLocale
            let dateString = dateFormatter.string(from: date)
            cell.userDate.text = dateString
            
            cell.userImage.sd_setShowActivityIndicatorView(true)
            cell.userImage.sd_setIndicatorStyle(.gray)
            cell.userImage.sd_setImage(with: URL(string: selfiArray[indexPath.row].user?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiArray[indexPath.row].thumbnail ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCSelfiesCell
            cell.userName.text = selfiArray[indexPath.row].caption ?? ""
            let date = dateFormatter.date(from: selfiArray[indexPath.row].createdAt!)!
            dateFormatter.dateFormat = "d MMM, yyyy"
            dateFormatter.locale = tempLocale
            let dateString = dateFormatter.string(from: date)
            cell.userDate.text = dateString
            
            cell.userImage.sd_setShowActivityIndicatorView(true)
            cell.userImage.sd_setIndicatorStyle(.gray)
            cell.userImage.sd_setImage(with: URL(string: selfiArray[indexPath.row].user?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let isvideo = selfiArray[indexPath.row].mimeType
        if isvideo == "video"{
            playVideo(selfiArray[indexPath.row].path ?? "")
        }else{
            moveToPhotoDetail(selfiArray[indexPath.row].path ?? "")
        }
    }
    
    private func moveToPhotoDetail(_ detailImageURL:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        vc.detailImageurl = detailImageURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playVideo(_ url:String){
        let videoURL = URL(string:url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchProductInfo(storeid, isRefresh: false)
    }
}

class VCSelfiesCell: UICollectionViewCell {

    @IBOutlet weak var imgGenral: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDate: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
}
