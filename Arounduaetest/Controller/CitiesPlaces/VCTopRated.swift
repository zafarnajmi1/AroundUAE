//
//  VCTopRated.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCTopRated: BaseController,IndicatorInfoProvider {
    
    @IBOutlet weak var TopratedCollectionView: UICollectionView!{
        didSet{
            self.TopratedCollectionView.delegate = self
            self.TopratedCollectionView.dataSource = self
            self.TopratedCollectionView.alwaysBounceVertical = true
        }
    }
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var placeArray = [Places]()
    var totalPages = 0
    var currentPage = 0
    var cityid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopratedCollectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        initialUI()
        fetchCitiesPlacesData()
    }
    
    fileprivate func setupDelegates(){
        self.TopratedCollectionView.emptyDataSetSource = self
        self.TopratedCollectionView.emptyDataSetDelegate = self
        self.TopratedCollectionView.reloadData()
    }
    
    private func fetchCitiesPlacesData(){
        startLoading("")
        CitiesPlacesManager().getCitiesPlaces((cityid,"\(1)","",""),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let placeResponse = response{
                        if placeResponse.success!{
                            self?.placeArray = placeResponse.data?.places ?? []
                            self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                            self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
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
        self.title = "Stores"
    }
}

extension VCTopRated{
    
    func initialUI(){
        
        TopratedCollectionView.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.TopratedCollectionView.spr_endRefreshing()
                        if let placeResponse = response{
                            if placeResponse.success!{
                                self?.placeArray = placeResponse.data?.places ?? []
                                self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.TopratedCollectionView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
        TopratedCollectionView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.TopratedCollectionView.spr_endRefreshing()
                return}
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.TopratedCollectionView.spr_endRefreshing()
                        if let placeResponse = response{
                            
                            if placeResponse.success!{
                                for cityplaces in placeResponse.data?.places ?? []{
                                    self?.placeArray.append(cityplaces)
                                }
                                self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.TopratedCollectionView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCTopRated: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopratedCell", for: indexPath) as! TopratedCell
        cell.setupPlaceCell(placeArray[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = placeArray[indexPath.row]._id{
           moveToPlaceDetail(id)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Top Rated".localized)
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


extension VCTopRated:topratedCellDelegate{
 
    func favouriteTapped(cell: TopratedCell){
        let indxpath = TopratedCollectionView.indexPath(for: cell)
        
        if let path = indxpath, let productid = placeArray[path.row]._id{
            addProductToFavourite(place_id: productid,toprated: cell)
        }
    }
    
    private func addProductToFavourite(place_id:String,toprated:TopratedCell){
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(place_id,
           successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if let favouriteResponse = response{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        if AppSettings.sharedSettings.user.favouritePlaces?.contains((place_id)) ?? false{
                            toprated.favroutieImage.image = #imageLiteral(resourceName: "Favourite-red")
                            toprated.btnToprated.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }else{
                            toprated.favroutieImage.image = #imageLiteral(resourceName: "Favourite")
                            toprated.btnToprated.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.09803921569, blue: 0.1490196078, alpha: 1)
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

