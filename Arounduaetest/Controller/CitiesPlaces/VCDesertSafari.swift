//
//  VCDesertSafari.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
import CoreLocation

class VCDesertSafari: UIViewController {

    @IBOutlet weak var btnsubmit: UIButtonMain!
    @IBOutlet weak var mapkitlocation: MKMapView!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var btntiwitter: UIButtonMain!
    @IBOutlet weak var btnfacebook: UIButtonMain!
    @IBOutlet weak var btnlinkedin: UIButtonMain!
    @IBOutlet weak var lblShareon: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var strcomos: CosmosView!
    @IBOutlet weak var lblDesrtsfari: UILabel!
    @IBOutlet weak var imgBaner: UIImageView!
    @IBOutlet weak var btnlikeimg: UIButtonMain!
    @IBOutlet weak var favouriteImage: UIImageView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var placeid = ""
    var selfiesArray = [Selfies]()
    var locationManager: CLLocationManager = CLLocationManager()
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaceDetailById()
        mapkitlocation.showsUserLocation = true
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
                    self?.setupPlaceDetail(responsedetail.data!)
                    self?.selfiesArray = responsedetail.data?.selfies ?? []
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
    
    private func setupPlaceDetail(_ place:Places){
        if(lang == "en")
        {
       lblDesrtsfari.text = place.title?.en ?? ""
      lblDesription.text = place.description?.en ?? ""
        }else{
            
            lblDesrtsfari.text = place.title?.ar ?? ""
            lblDesription.text = place.description?.ar ?? ""
        }
      strcomos.rating = place.averageRating ?? 0.0

      imgBaner.sd_setShowActivityIndicatorView(true)
      imgBaner.sd_setIndicatorStyle(.gray)
      imgBaner.sd_setImage(with: URL(string: place.images?.first?.path ?? ""))
        if AppSettings.sharedSettings.user.favouritePlaces?.contains(placeid) ?? false{
            self.favouriteImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.btnlikeimg.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.favouriteImage.image = #imageLiteral(resourceName: "Favourite")
            self.btnlikeimg.backgroundColor = #colorLiteral(red: 0.6, green: 0.537254902, blue: 0.4901960784, alpha: 1)
        }
        
        let location = CLLocation(latitude: place.location![0], longitude: place.location![1])
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapkitlocation.setRegion(region, animated: true)
        
    }
    
    private func setFavourite(_ placeid: String){
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(placeid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        AppSettings.sharedSettings.user = storeResponse.data!
                        if AppSettings.sharedSettings.user.favouritePlaces?.contains(placeid) ?? false{
                            self?.favouriteImage.image = #imageLiteral(resourceName: "Favourite-red")
                            self?.btnlikeimg.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }else{
                            self?.favouriteImage.image = #imageLiteral(resourceName: "Favourite")
                            self?.btnlikeimg.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
                        }
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: nil)
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
    
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Desert Safari".localized
        if(lang == "en"){
           self.addBackButton()
        }else{
            self.showArabicBackButton()
        }
        if AppSettings.sharedSettings.accountType == "seller"{
            btnlikeimg.isHidden = true
            favouriteImage.isHidden = true
        }else{
            btnlikeimg.isHidden = false
            favouriteImage.isHidden = false
        }
     self.lblShareon.text = "Share on".localized
        self.btnsubmit.setTitle("Submit Feedback".localized, for: .normal)
        self.lbllocation.text = "Location".localized
    }

    @IBAction func makePlaceFavourite(_ sender: Any){
        if placeid != "" && placeid.count > 0{
           setFavourite(placeid)
        }
    }
    
    @IBAction func review(_ sender: Any){
        moveToPopVC(placeid)
    }
    
    private func moveToPopVC(_ placeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopUp") as! VCPopUp
        vc.placeid = placeid
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movetopop"{
            placeid = (sender as? String)!
        }
    }
    
    @IBAction func btnLinkedinClick(_ sender: Any){
        guard let url = URL(string: shareduserinfo.setting.linkedin ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tbnFacebookClick(_ sender: Any){
        guard let url = URL(string: shareduserinfo.setting.facebook ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnTwitterClick(_ sender: Any){
        guard let url = URL(string: shareduserinfo.setting.twitter ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func selfieVideo(_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelfiVedioPlacesVC") as! SelfiVedioPlacesVC
        vc.placeid = placeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareApp(_ sender: Any){
        let text = "http://216.200.116.25/around-uae/"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

