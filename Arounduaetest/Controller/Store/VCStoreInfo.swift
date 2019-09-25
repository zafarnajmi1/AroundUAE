//
//  VCStoreInfo.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos
import SDWebImage
import AVFoundation
import AVKit
import GoogleMaps
import CoreLocation
class VCStoreInfo: UIViewController,IndicatorInfoProvider,CLLocationManagerDelegate {
   var locationManager = CLLocationManager()
    @IBOutlet weak var tableviewReeviewConstraint: NSLayoutConstraint!
    @IBOutlet var lblInstinct: UILabel!
    @IBOutlet var lblAdress: UILabel!
    @IBOutlet var btnSubmitFeedBack: UIButtonMain!
    @IBOutlet var lblWords: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var submitFeedbackBtn: UIButton!
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var collectionsectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
  
    @IBOutlet weak var googleMapsView: GMSMapView!
    
   
    var storereview:[CanReviewUsers]?
    var reviewArray:[Reviews]?
    var galleryArray = [Gallery]()
    var storeid = ""
    var CitiesArray = [false,false,true,true,false,true]
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        if isResturant{
            return IndicatorInfo.init(title: "Info".localized)
        }
        return IndicatorInfo.init(title: "Store Info".localized)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        submitFeedbackBtn.setTitle("Submit Feedback".localized, for: .normal)
        if AppSettings.sharedSettings.accountType == "seller"{
            btnSubmitFeedBack.isHidden = true
        }else{
            if let reviews = storereview, reviews.count > 0{
                self.btnSubmitFeedBack.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
                self.btnSubmitFeedBack.borderColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
                self.btnSubmitFeedBack.isUserInteractionEnabled = true
            }else{
                self.btnSubmitFeedBack.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.btnSubmitFeedBack.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.btnSubmitFeedBack.isUserInteractionEnabled = false
            }
         }
        fetchProductInfo(storeid, isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("RemoveSelfie"), object: nil)
    }
    
    @IBAction func switchTab(_ sender:UIButton){
        let parentViewController = self.parent! as! VCStoreTab
        parentViewController.moveToViewController(at: 2)
    }

    private func fetchProductInfo(_ storeId: String, isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        StoreManager().getStoreDetail(storeId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let productResponse = response{
                        if productResponse.success!{
                            self?.storeid = productResponse.data?._id ?? ""
                            self!.loadGoogleMap(lat: (productResponse.data?.latitude)!, long: (productResponse.data?.longitude)!)
                            self?.galleryArray = productResponse.data?.gallery ?? []
                            self?.collectionsectionView.reloadData()
                            self?.setCollectionViewHeight()
                            self?.lblInstinct.text = (self?.lang ?? "" == "en") ? productResponse.data?.storeName?.en ?? "" :
                                productResponse.data?.storeName?.ar ?? ""
                            self?.lblAdress.text = productResponse.data?.location ?? ""
                            self?.lblWords.text = (self?.lang ?? "" == "en") ? productResponse.data?.description?.en ?? "" : productResponse.data?.description?.ar ?? ""
                            self?.storeImage.sd_addActivityIndicator()
                            self?.storeImage.sd_setIndicatorStyle(.gray)
                            self?.storeImage.sd_setImage(with: URL(string: productResponse.data?.image ?? ""))
                            self?.storereview = productResponse.data?.canReviewUsers
                            self?.reviewArray = productResponse.data?.reviews
                            self?.ratingView.rating = productResponse.data?.averageRating ?? 0.0
                            self?.tableViewReviews.reloadData()
                            self?.setViewHeight()
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
    
    
    func loadGoogleMap(lat:Double, long: Double) {
        
      
        let position = CLLocationCoordinate2DMake(lat, long)
        let marker = GMSMarker(position: position)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        self.googleMapsView.camera = camera
        
        marker.map = self.googleMapsView
        
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "\(title)"
            marker.map = self.googleMapsView
            
        }
    }
    
    
    @IBAction func review(_ sender: Any){
        if AppSettings.sharedSettings.accountType == "buyer"{
            moveToPopVC()
        }
    }
    
    private func moveToPopVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopUp") as! VCPopUp
        vc.productid = storeid
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setViewHeight(){
        var tableViewHeight:CGFloat = 0
        for i in 0..<self.tableViewReviews.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.tableViewReviews, heightForRowAt: IndexPath(row: i, section: 0))
        }
        tableviewReeviewConstraint.constant = tableViewHeight + 20
        self.tableViewReviews.setNeedsDisplay()
    }
    
    private func setCollectionViewHeight(){
        collectionViewHeightConstraint.constant = collectionsectionView.collectionViewLayout.collectionViewContentSize.height + 10
        self.collectionsectionView.setNeedsDisplay()
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
}

extension VCStoreInfo: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "reviewcell", for: indexPath) as! ReviewCell
        cell.setupReviewCell(review: (reviewArray?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

class ReviewCell:UITableViewCell{
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    
    override func awakeFromNib() {
        userImage.image = nil
        userName.text = nil
        userComment.text = nil
        reviewDate.text = nil
    }
    
    func setupReviewCell(review:Reviews){
        userImage.sd_setShowActivityIndicatorView(true)
        userImage.sd_setIndicatorStyle(.gray)
        userImage.sd_setImage(with: URL(string: review.user?.image ?? ""))
        userName.text = review.user?.fullName ?? ""
        userComment.text = review.comment
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: review.createdAt ?? "")!
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        reviewDate.text = dateString
    }
}

extension VCStoreInfo: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isvideo = galleryArray[indexPath.row].mimeType
        if isvideo == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
            cell.videoImage.sd_setShowActivityIndicatorView(true)
            cell.videoImage.sd_setIndicatorStyle(.gray)
            cell.videoImage.sd_setImage(with: URL(string: galleryArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            cell.normalImage.sd_setShowActivityIndicatorView(true)
            cell.normalImage.sd_setIndicatorStyle(.gray)
            cell.normalImage.sd_setImage(with: URL(string: galleryArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isvideo = galleryArray[indexPath.row].mimeType
        if isvideo == "video"{
            playVideo()
        }else{
            moveToPhotoDetail(galleryArray[indexPath.row].path ?? "")
        }
    }
    
    private func moveToPhotoDetail(_ detailImageURL:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        vc.detailImageurl = detailImageURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func playVideo(){
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
}

class VideoCell:UICollectionViewCell{
    @IBOutlet weak var videoImage:UIImageView!
}

class ImageCell:UICollectionViewCell{
    @IBOutlet weak var normalImage:UIImageView!
}

extension VCStoreInfo : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = marker as? GMSMarker
        {
            
        }
        return true
    }
}
