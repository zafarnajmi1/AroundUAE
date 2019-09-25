//
//  VCFavouritePlaces.swift
//  AroundUAE
//
//  Created by Macbook on 28/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import  XLPagerTabStrip
import DZNEmptyDataSet

class VCFavouritePlaces: BaseController,IndicatorInfoProvider{
    
    @IBOutlet var favouritePlacesTableView: UITableView!{
        didSet{
            self.favouritePlacesTableView.delegate = self
            self.favouritePlacesTableView.dataSource = self
        }
    }
    
    var favouritePlacesList = [Places]()
    var totalPages = 0
    var currentPage = 0
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        getFavouritePlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Places".localized
    }
    
    fileprivate func setupDelegates(){
        self.favouritePlacesTableView.emptyDataSetSource = self
        self.favouritePlacesTableView.emptyDataSetDelegate = self
        self.favouritePlacesTableView.tableFooterView = UIView()
        self.favouritePlacesTableView.reloadData()
    }
    
    private func getFavouritePlaces(){
        startLoading("")
        CitiesPlacesManager().getFavouritePlacesList("\(1)",successCallback:
        {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let FavouritePlacesData = response{
                        if FavouritePlacesData.success!{
                            self?.favouritePlacesList = FavouritePlacesData.data?.places ?? []
                            self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                            self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                        }
                        else{
                            if(self?.lang ?? "" == "en")
                            {
                            self?.alertMessage(message:(FavouritePlacesData.message?.en ?? "").localized, completionHandler: nil)
                            }else
                            {
                               self?.alertMessage(message:(FavouritePlacesData.message?.ar ?? "").localized, completionHandler: nil)
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Places".localized)
    }
}

extension VCFavouritePlaces{
    
    func initialUI(){
        
        favouritePlacesTableView.spr_setTextHeader { [weak self] in
          
            self?.currentPage = 0
            CitiesPlacesManager().getFavouritePlacesList("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouritePlacesTableView.spr_endRefreshing()
                        if let FavouritePlacesData = response{
                            if FavouritePlacesData.success!{
                                self?.favouritePlacesList = FavouritePlacesData.data?.places ?? []
                                self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                                self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                            }else{
                                if(self?.lang ?? "" == "en")
                                {
                                self?.alertMessage(message:(FavouritePlacesData.message?.en ?? "").localized, completionHandler: nil)
                                }else
                                {
                                     self?.alertMessage(message:(FavouritePlacesData.message?.ar ?? "").localized, completionHandler: nil)
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
                    self?.favouritePlacesTableView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                    }
                }
            }
        
            favouritePlacesTableView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.favouritePlacesTableView.spr_endRefreshing()
                return}
            
             CitiesPlacesManager().getFavouritePlacesList("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouritePlacesTableView.spr_endRefreshing()
                        if let FavouritePlacesData = response{
                            if FavouritePlacesData.success!{
                                for place in FavouritePlacesData.data?.places ?? []{
                                    self?.favouritePlacesList.append(place)
                                }
                                self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                                self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                            }else{
                                if(self?.lang ?? "" == "en")
                                {
                                self?.alertMessage(message:(FavouritePlacesData.message?.en ?? "").localized, completionHandler: nil)
                                }else
                                {
                                    self?.alertMessage(message:(FavouritePlacesData.message?.ar ?? "").localized, completionHandler: nil)
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
                    self?.favouritePlacesTableView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCFavouritePlaces:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePlacesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFavouritePlaces") as! CellFavouritePlaces
        cell.setupCellData(favouritePlacesList[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppSettings.sharedSettings.accountType != "seller"{
            if let id = favouritePlacesList[indexPath.row]._id{
                moveToPlaceDetail(id)
            }
        }
    }
    
    private func moveToPlaceDetail(_ placeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCDesertSafari") as! VCDesertSafari
        vc.placeid = placeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        getFavouritePlaces()
    }
}

extension VCFavouritePlaces: PotocolCellFavourite{
    
    func tapOnfavouritePlacescell(cell: CellFavouritePlaces){
        let indexpath = favouritePlacesTableView.indexPath(for: cell)
        let place = favouritePlacesList[indexpath?.row ?? 0]
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(place._id ?? "",
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let favouriteResponse = response{
                    if favouriteResponse.success!{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        self?.favouritePlacesList.remove(at: indexpath?.row ?? 0)
                        self?.favouritePlacesTableView.reloadData()
                    }else{
                        if(self?.lang ?? "" == "en")
                        {
                        self?.alertMessage(message: (favouriteResponse.message?.en ?? "").localized, completionHandler: nil)
                        }else
                        {
                            self?.alertMessage(message: (favouriteResponse.message?.ar ?? "").localized, completionHandler: nil)
                        }
                    }
                }else{
                    if(self?.lang ?? "" == "en")
                    {
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                    }else
                    {
                     self?.alertMessage(message: response?.message?.ar ?? "", completionHandler: nil)
                    }
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
}
