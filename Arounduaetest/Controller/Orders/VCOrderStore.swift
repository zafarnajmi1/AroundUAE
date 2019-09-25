//
//  VCStores.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

enum OrderType:String {
    case manageproduct
    case myorder
    case manageaboutpage
    case SelfieReview
}

class VCOrderStore: BaseController{
    
    @IBOutlet var collectionViewStores: UICollectionView!{
        didSet{
            self.collectionViewStores.delegate = self
            self.collectionViewStores.dataSource = self
            self.collectionViewStores.alwaysBounceVertical = true
        }
    }
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var storelist = [Stores]()
    var totalPages = 0
    var currentPage = 0
    var isEmptyViewShown = false
    var ordertype:OrderType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewStores.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        initialUI()
        fetchStoresData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Stores".localized
        self.setNavigationBar()
        if lang == "en"{
            addBackButton()
        }else{
            showArabicBackButton()
        }
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewStores.emptyDataSetSource = self
        self.collectionViewStores.emptyDataSetDelegate = self
        self.collectionViewStores.reloadData()
    }
    
    private func fetchStoresData(){
        
        startLoading("")
        ProfileManager().UserStores("\(currentPage + 1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let storeResponse = response{
                        if storeResponse.success!{
                            self?.storelist = storeResponse.data?.stores ?? []
                            
                            let array = self?.storelist.map({$0._id})
                            for i in 0..<(AppSettings.sharedSettings.user.stores?.count ?? 0){
                                if array?.contains((AppSettings.sharedSettings.user.stores ?? [])[i]) ?? false{
                                    
                                }else{
                                    if self?.storelist.count ?? 0 > 0{
                                        self?.storelist.remove(at: i)
                                    }
                                }
                            }
                            self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                            self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
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
                self?.finishLoading()
                self?.setupDelegates()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}

extension VCOrderStore{
    
    func initialUI(){
        
        collectionViewStores.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
            StoreManager().getStores("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionViewStores.spr_endRefreshing()
                        if let storeResponse = response{
                            if storeResponse.success!{
                                self?.storelist = storeResponse.data?.stores ?? []
                                self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
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
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                }
            }
        }
        
        collectionViewStores.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.collectionViewStores.spr_endRefreshing()
                return}
            
            StoreManager().getStores("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionViewStores.spr_endRefreshing()
                        if let storeResponse = response{
                            if storeResponse.success!{
                                for store in storeResponse.data?.stores ?? []{
                                    self?.storelist.append(store)
                                }
                                self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
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
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                }
            }
        }
    }
}

extension VCOrderStore: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storelist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStores", for: indexPath) as! CellStores
        let store = storelist[indexPath.row]
        cell.setupStoreCell(store)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

        switch ordertype! {
            case OrderType.manageproduct:
                let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ManageProductVC") as! ManageProductVC
                vc.storeid = storelist[indexPath.row]._id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)

            case OrderType.myorder:
                if let id = storelist[indexPath.row]._id{
                    moveToOrderVC(id)
                }
            
            case OrderType.manageaboutpage:
                let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ManageAboutPageVC") as! ManageAboutPageVC
                vc.storeObject = storelist[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)

           case .SelfieReview:
                let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SetSelfiVedioVC") as! SetSelfiVedioVC
                vc.storeid = storelist[indexPath.row]._id ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func moveToOrderVC(_ storeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCMyOrders") as! VCMyOrders
        vc.storeid = storeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchStoresData()
    }
}

