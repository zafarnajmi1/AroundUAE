//
//  VCGenralServices.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class VCCities: BaseController{
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }

    var CitiesArray = [Cities]()
    var totalPages = 0
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        initialUI()
        fetchCitiesData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Cities".localized
        self.setNavigationBar()
        if(lang == "en")
        {
         self.addBackButton()
        }else{
            self.showArabicBackButton()
        }
    }
    
    fileprivate func setupDelegates(){
         self.collectionView.emptyDataSetSource = self
         self.collectionView.emptyDataSetDelegate = self
         self.collectionView.reloadData()
    }

    private func fetchCitiesData(){
        startLoading("")
        CitiesPlacesManager().getCities("\(1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let citiesResponse = response{
                        if(citiesResponse.success!){
                            self?.CitiesArray = citiesResponse.data?.cities ?? []
                            self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                        }else{
                            if(self?.lang ?? "" == "en")
                            {
                            self?.alertMessage(message:(citiesResponse.message?.en ?? "").localized, completionHandler: nil)
                            }else
                            {
                                self?.alertMessage(message:(citiesResponse.message?.ar ?? "").localized, completionHandler: nil)
                            }
                            
                        }
                     }else{
                        if(self?.lang ?? "" == "en")
                        {
                        self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }else
                        {
                            self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                        }
                    }
                        
                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}

extension VCCities{
    
    func initialUI(){
        
        collectionView.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
            CitiesPlacesManager().getCities("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionView.spr_endRefreshing()
                        if let citiesResponse = response{
                            if(citiesResponse.success!){
                                self?.CitiesArray = citiesResponse.data?.cities ?? []
                                self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                                self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                            }else{
                                if(self?.lang ?? "" == "en")
                                {
                                self?.alertMessage(message:(citiesResponse.message?.en ?? "").localized, completionHandler: nil)
                                }else
                                {
                                    self?.alertMessage(message:(citiesResponse.message?.ar ?? "").localized, completionHandler: nil)
                                }
                            }
                        }else{
                            if(self?.lang ?? "" == "en")
                            {
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                            }else
                            {
                                 self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                            }
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
        collectionView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.collectionView.spr_endRefreshing()
                return}
            
             CitiesPlacesManager().getCities("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionView.spr_endRefreshing()
                        if let citiesResponse = response{
                            if citiesResponse.success!{
                                for city in citiesResponse.data?.cities ?? []{
                                    self?.CitiesArray.append(city)
                                }
                                self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                                self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                            }else{
                                if(self?.lang ?? "" == "en")
                                {
                                self?.alertMessage(message:(citiesResponse.message?.en ?? "").localized, completionHandler: nil)
                                }else
                                {
                                  self?.alertMessage(message:(citiesResponse.message?.ar ?? "").localized, completionHandler: nil)
                                }
                            }
                        }else{
                            if(self?.lang ?? "" == "en")
                            {
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                            }else
                            {
                                self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                            }
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCCities:UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CitiesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCCitiesCell
        let city = CitiesArray[indexPath.row]
        cell.setupCities(city)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let city = CitiesArray[indexPath.row]
        
        if self.lang == "en" {
            moveToCityDetail(city._id!, (city.title?.en)!)
        }
        else{
            moveToCityDetail(city._id!, (city.title?.ar)!)
        }
        
        
        
//            if let id = CitiesArray[indexPath.row]._id{
//                moveToCityDetail(id,)
//            }
    }
    
    private func moveToCityDetail(_ cityId:String,_ cityName:String){
//       let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "VCPlaces") as! VCPlaces
//        vc.cityId = cityId
//        vc.moveToViewController(at: 1)
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCEvents") as! VCEvents
        vc.cityId = cityId
        vc.cityName = cityName
//        vc.moveToViewController(at: 1)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
       // let parentViewController = self.parent! as! VCPlaces
//        parentViewController.moveToViewController(at: 1)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchCitiesData()
    }
}
