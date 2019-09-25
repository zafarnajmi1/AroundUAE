//
//  ManageProductVC.swift
//  Arounduaetest
//
//  Created by Apple on 29/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class ManageProductVC: BaseController {
   
    var productarray = [Products]()
    var storeid:String!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var collectionViewProduct: UICollectionView!{
        didSet{
            collectionViewProduct.delegate = self
            collectionViewProduct.dataSource = self
            collectionViewProduct.alwaysBounceVertical = true
            collectionViewProduct.addSubview(refreshControl)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    fileprivate func setupDelegates(){
        self.collectionViewProduct.emptyDataSetSource = self
        self.collectionViewProduct.emptyDataSetDelegate = self
        self.collectionViewProduct.reloadData()
    }
    
    @objc func refreshTableView() {
        fetchProductInfo(storeid, isRefresh: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products".localized
        self.setNavigationBar()
        fetchProductInfo(storeid, isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if lang == "en"{
            addBackButton()
        }else{
            showArabicBackButton()
        }
    }
    
    private func fetchProductInfo(_ storeId: String, isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        StoreManager().getStoreDetail(storeId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if isRefresh == false {
                        self?.finishLoading()
                    }else {
                        self?.refreshControl.endRefreshing()
                    }
                    if let productResponse = response{
                        if productResponse.success!{
                            self?.productarray = productResponse.data?.products ?? []
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}

extension ManageProductVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageProductCell", for: indexPath) as! ManageProductCell
        cell.setupCellData(product:productarray[indexPath.row])
        return cell
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        
    }
}
