//
//  VCCategories.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DZNEmptyDataSet

class VCCategories: BaseController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet var groupCollectionView: UICollectionView!{
        didSet{
            self.groupCollectionView.delegate = self
            self.groupCollectionView.dataSource = self
            self.groupCollectionView.alwaysBounceVertical = true
            self.groupCollectionView.addSubview(refreshControl)
        }
    }
   
    var grouplist = [Groups]()
    var storeGroup:Groups!
    var resturantGroup:Groups!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupCollectionView.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        setupDefaultGroups()
        fetchGroupsData(isRefresh: false)
    }
    
   
    fileprivate func setupDelegates(){
        self.groupCollectionView.emptyDataSetSource = self
        self.groupCollectionView.emptyDataSetDelegate = self
        self.groupCollectionView.reloadData()
    }
    
    @objc func refreshTableView() {
        fetchGroupsData(isRefresh: true)
    }
    
    private func setupDefaultGroups(){
        storeGroup = Groups(title: Title(en: "Stores", ar: "Stores"),divisions:nil, image: nil, isActive: true, isFeatured: true, _id: "0123456")
        resturantGroup = Groups(title: Title(en: "Resturants", ar: "Resturants"),divisions:nil, image: nil, isActive: true, isFeatured: true, _id: "0123456")
    }
    
    private func fetchGroupsData(isRefresh: Bool){
      
        if isRefresh == false{
            startLoading("")
        }
        
        GDSManager().getGroups(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
    
                if let groupResponse = response{
                    if groupResponse.success!{
                        self?.grouplist = groupResponse.data?.groups ?? []
                        
                        self?.grouplist.insert((self?.storeGroup)!, at: 0)
                        self?.grouplist.insert((self?.resturantGroup)!, at:1)
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
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                self?.setupDelegates()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}

extension VCCategories{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  grouplist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCategories", for: indexPath) as! CellCategories
        
        var obj = grouplist[indexPath.row]
        if obj.title?.en == "Stores"{
            obj.title?.ar = "Stores".localized
            cell.setupCell(obj, groupImage: #imageLiteral(resourceName: "3"))
        }else if obj.title?.en == "Resturants" {
            obj.title?.ar = "Resturants".localized
            cell.setupCell(obj, groupImage: #imageLiteral(resourceName: "4"))
        }else{
            cell.setupCell(obj, groupImage: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == 0{
            self.moveToStores()
        }else if indexPath.row == 1{
            self.moveToResturants()
        }else{
            self.moveToSubDivisons(grouplist[indexPath.row]._id ?? "", groupname: (lang == "en") ? grouplist[indexPath.row].title?.en ?? "" : grouplist[indexPath.row].title?.ar ?? "")
        }
    }
    
    private func moveToSubDivisons(_ groupId:String,groupname:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCSubDivisions") as! VCSubDivisions
        vc.groupId = groupId
        vc.groupName = groupname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToStores(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStores") as! VCStores
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToResturants(){
        
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCResturants") as! VCResturants
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchGroupsData(isRefresh: false)
    }
}

extension UICollectionView{
    func adjustDesign(width: CGFloat){
        let collectionViewSize = self.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewSize.itemSize.width = width
    }
}
