//
//  VCStores.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class VCStores: BaseController{
    
    @IBOutlet var collectionViewStores: UICollectionView!{
        didSet{
            self.collectionViewStores.delegate = self
            self.collectionViewStores.dataSource = self
            self.collectionViewStores.alwaysBounceVertical = true
        }
    }
    
    var storelist = [Stores]()
    var totalPages = 0
    var currentPage = 0
    var isEmptyViewShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewStores.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        initialUI()
        fetchStoresData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Stores"
        self.setNavigationBar()
        self.addBackButton()
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewStores.emptyDataSetSource = self
        self.collectionViewStores.emptyDataSetDelegate = self
        self.collectionViewStores.reloadData()
    }
    
    private func fetchStoresData(){
        
        startLoading("")
        StoreManager().getStores("\(currentPage + 1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let storeResponse = response{
                        if storeResponse.success!{
                            self?.storelist = storeResponse.data?.stores ?? []
                            self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                            self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
                        }else{
                            self?.alertMessage(message:(storeResponse.message?.en ?? "").localized, completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
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

extension VCStores{
    
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
                                self?.alertMessage(message:(storeResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
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
                                self?.alertMessage(message:(storeResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionViewStores.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCStores: UICollectionViewDataSource,UICollectionViewDelegate{
    
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
        if let id = storelist[indexPath.row]._id{
            moveToStoreDetail(id)
        }
    }
    
    private func moveToStoreDetail(_ storeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStoreTab") as! VCStoreTab
        vc.storeid = storeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchStoresData()
    }
}

