//
//  VCResturants.swift
//  AroundUAE
//
//  Created by Apple on 27/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCResturants: BaseController{
    
    @IBOutlet var collectionViewStores: UICollectionView!{
        didSet{
            self.collectionViewStores.delegate = self
            self.collectionViewStores.dataSource = self
        }
    }
    
    var resturantslist = [Stores]()
    var totalPages = 0
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewStores.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        initialUI()
        fetchResturantsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Restaurants".localized
        self.setNavigationBar()
        self.addBackButton()
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewStores.emptyDataSetSource = self
        self.collectionViewStores.emptyDataSetDelegate = self
        self.collectionViewStores.reloadData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
       fetchResturantsData()
    }
    
    private func fetchResturantsData(){
        
        startLoading("")
        StoreManager().getResturants( "\(currentPage + 1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let resturantsResponse = response{
                        if(resturantsResponse.data?.restaurants ?? []).count == 0{
                            
                        }else{
                            self?.resturantslist = resturantsResponse.data?.restaurants ?? []
                            self?.currentPage = resturantsResponse.data?.pagination?.page ?? 1
                            self?.totalPages = resturantsResponse.data?.pagination?.pages ?? 0
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
}

extension VCResturants{
    
    func initialUI(){
        
        collectionViewStores.spr_setTextHeader { [weak self] in

            self?.currentPage = 0
            StoreManager().getResturants( "\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionViewStores.spr_endRefreshing()
                        if let storeResponse = response{
                            if(storeResponse.data?.restaurants ?? []).count == 0{
                            
                            }else{
                                self?.resturantslist = storeResponse.data?.restaurants ?? []
                                self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
                            }
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
           collectionViewStores.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.collectionViewStores.spr_endRefreshing()
                return}
            
            StoreManager().getResturants("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionViewStores.spr_endRefreshing()
                        if let resturantsResponse = response{
                            for resturant in resturantsResponse.data?.restaurants ?? []{
                                self?.resturantslist.append(resturant)
                            }
                            self?.currentPage = resturantsResponse.data?.pagination?.page ?? 1
                            self?.totalPages = resturantsResponse.data?.pagination?.pages ?? 0
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                        
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCResturants: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resturantslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStores", for: indexPath) as! CellStores
        let store = resturantslist[indexPath.row]
        cell.setupStoreCell(store)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let id = resturantslist[indexPath.row]._id{
            moveToResturantDetail(id)
        }
    }
    
    private func moveToResturantDetail(_ storeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStoreTab") as! VCStoreTab
        vc.storeid = storeid
        isResturant = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
