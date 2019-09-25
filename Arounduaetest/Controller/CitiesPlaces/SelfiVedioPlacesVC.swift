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

class SelfiVedioPlacesVC: BaseController,IndicatorInfoProvider{
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var selfiesArray = [Selfies]()
    var totalPages = 0
    var currentPage = 0
    var placeid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        collectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
    }
    
    private func getPlaceDetailById(){
        if placeid == ""{
            return
        }
        startLoading("")
        CitiesPlacesManager().getPlaceDetail(placeid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let responsedetail = response{
                    self?.selfiesArray = responsedetail.data?.selfies ?? []
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
               self?.setupDelegates()
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Selfie/Video".localized)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Selfie/Video".localized
        addSelfieButton()
        getPlaceDetailById()
    }
    
    func addSelfieButton(backImage: UIImage = #imageLiteral(resourceName: "Takeselfie")) {
        let button =  UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "Takeselfie"), for: .normal)
        button.addTarget(self, action: #selector(onChatButtonClciked), for: .touchUpInside)
        button.frame = CGRect(x:0,y:0,width:53,height:31)
        button.imageEdgeInsets = UIEdgeInsetsMake(-1, -32, 1, 32)
        let label = UILabel(frame: CGRect(x:0,y:5,width: 70,height:20))
        label.font = UIFont(name: "Arial", size: 10)
        label.text = "Take Selfie"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.setRightBarButtonItems([barButton], animated: true)
    }
    
    @objc func onChatButtonClciked() {
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CaptureSelfiePopupVC") as! CaptureSelfiePopupVC
        vc.placeid = placeid
        self.present(vc, animated: true, completion: nil)
    }

    fileprivate func setupDelegates(){
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.collectionView.reloadData()
    }
}

extension SelfiVedioPlacesVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selfiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let isvideo = selfiesArray[indexPath.row].mimeType
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       
        if isvideo == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralVideoCell", for: indexPath) as! VCSelfiesCell
            cell.userName.text = selfiesArray[indexPath.row].caption ?? ""
            let date = dateFormatter.date(from: selfiesArray[indexPath.row].createdAt!)!
            dateFormatter.dateFormat = "d MMM, yyyy"
            dateFormatter.locale = tempLocale
            let dateString = dateFormatter.string(from: date)
            cell.userDate.text = dateString
            
            cell.userImage.sd_setShowActivityIndicatorView(true)
            cell.userImage.sd_setIndicatorStyle(.gray)
            cell.userImage.sd_setImage(with: URL(string: selfiesArray[indexPath.row].user?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiesArray[indexPath.row].thumbnail ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCSelfiesCell
            cell.userName.text = selfiesArray[indexPath.row].caption ?? ""
            let date = dateFormatter.date(from: selfiesArray[indexPath.row].createdAt!)!
            dateFormatter.dateFormat = "d MMM, yyyy"
            dateFormatter.locale = tempLocale
            let dateString = dateFormatter.string(from: date)
            cell.userDate.text = dateString
            
            cell.userImage.sd_setShowActivityIndicatorView(true)
            cell.userImage.sd_setIndicatorStyle(.gray)
            cell.userImage.sd_setImage(with: URL(string: selfiesArray[indexPath.row].user?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiesArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let isvideo = selfiesArray[indexPath.row].mimeType
        if isvideo == "video"{
            playVideo(selfiesArray[indexPath.row].path ?? "")
        }else{
            moveToPhotoDetail(selfiesArray[indexPath.row].path ?? "")
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
        
    }
}
