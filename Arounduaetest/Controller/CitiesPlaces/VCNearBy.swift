//
//  VCNearBy.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos
import CoreLocation
import DZNEmptyDataSet

class VCNearBy: BaseController,IndicatorInfoProvider,CLLocationManagerDelegate {
   
    @IBOutlet weak var NearbyCollectionview: UICollectionView!{
        didSet{
            self.NearbyCollectionview.delegate = self
            self.NearbyCollectionview.dataSource = self
            self.NearbyCollectionview.alwaysBounceVertical = true
        }
    }
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var placeArray = [Places]()
    var totalPages = 0
    var currentPage = 0
    var cityid = ""
    private var long:Double?
    private var lat:Double?
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        
        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NearbyCollectionview.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        initialUI()
        fetchCitiesPlacesData()
//        let parentViewController = self.parent! as! VCPlaces
//        parentViewController.moveToViewController(at: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    fileprivate func setupDelegates(){
        self.NearbyCollectionview.emptyDataSetSource = self
        self.NearbyCollectionview.emptyDataSetDelegate = self
        self.NearbyCollectionview.reloadData()
    }
    
    private func fetchCitiesPlacesData(){
        startLoading("")
        CitiesPlacesManager().getCitiesPlaces((cityid,"\(1)","",""),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let citiesPlacesResponse = response{
                        if citiesPlacesResponse.success!{
                            self?.placeArray = citiesPlacesResponse.data?.places ?? []
                            self?.currentPage = citiesPlacesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = citiesPlacesResponse.data?.pagination?.pages ?? 0
                        }else{
                            self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.setupDelegates()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Stores".localized
        locationManager.requestWhenInUseAuthorization()
        print("did load")
        print(locationManager)
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
}

extension VCNearBy{
    
    func initialUI(){
        
        NearbyCollectionview.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.NearbyCollectionview.spr_endRefreshing()
                        if let citiesPlacesResponse = response{
                            if citiesPlacesResponse.success!{
                                self?.placeArray = citiesPlacesResponse.data?.places ?? []
                                self?.currentPage = citiesPlacesResponse.data?.pagination?.page ?? 1
                                self?.totalPages = citiesPlacesResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.NearbyCollectionview.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                    }
                }
            }
        
            NearbyCollectionview.spr_setIndicatorFooter {[weak self] in
                if((self?.currentPage)! >= (self?.totalPages)!){
                    self?.NearbyCollectionview.spr_endRefreshing()
                    return}
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.NearbyCollectionview.spr_endRefreshing()
                        if let cityplacesResponse = response{
                            if cityplacesResponse.success!{
                                for cityplaces in cityplacesResponse.data?.places ?? []{
                                    self?.placeArray.append(cityplaces)
                                }
                                self?.currentPage = cityplacesResponse.data?.pagination?.page ?? 1
                                self?.totalPages = cityplacesResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.NearbyCollectionview.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                }
            }
        }
    }
}

extension VCNearBy: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCell", for: indexPath) as! NearByCell
        let place = placeArray[indexPath.row]
        cell.delegate = self
        cell.setupPlaceCell(place)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = placeArray[indexPath.row]._id{
            moveToPlaceDetail(id)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Near By".localized)
    }
    
    private func moveToPlaceDetail(_ placeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCDesertSafari") as! VCDesertSafari
        vc.placeid = placeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchCitiesPlacesData()
    }
}

extension VCNearBy:nearbyCellDelegate{
    
    func favouriteTapped(cell: NearByCell){
        let indxpath = NearbyCollectionview.indexPath(for: cell)
        
        if let path = indxpath, let productid = placeArray[path.row]._id{
            addProductToFavourite(place_id: productid,nearby: cell)
        }
    }

    private func addProductToFavourite(place_id:String,nearby:NearByCell){
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(place_id,
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if let favouriteResponse = response{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        if AppSettings.sharedSettings.user.favouritePlaces?.contains((place_id)) ?? false{
                            nearby.favroutieImage.image = #imageLiteral(resourceName: "Favourite-red")
                            nearby.btnFavourit.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }else{
                            nearby.favroutieImage.image = #imageLiteral(resourceName: "Favourite")
                            nearby.btnFavourit.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.09803921569, blue: 0.1490196078, alpha: 1)
                        }
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                    self?.finishLoading()
                }
        }){[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}
