//
//  VCDivisions.swift
//  Arounduaetest
//
//  Created by Apple on 02/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCSubDivisions: BaseController {

    @IBOutlet var collectionViewSubDivison: UICollectionView!{
        didSet{
            self.collectionViewSubDivison.delegate = self
            self.collectionViewSubDivison.dataSource = self
            self.collectionViewSubDivison.alwaysBounceVertical = true
            self.collectionViewSubDivison.addSubview(refreshControl)
        }
    }
    
    var subDivisonlist = [GroupDivisonData]()
    var groupId = ""
    var groupName = ""
    var divisionid = ""
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
        collectionViewSubDivison.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        fetchSubDivisonsData(isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = groupName
        self.setNavigationBar()
        self.addBackButton()
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewSubDivison.emptyDataSetSource = self
        self.collectionViewSubDivison.emptyDataSetDelegate = self
        self.collectionViewSubDivison.reloadData()
    }
    
    @objc func refreshTableView() {
        fetchSubDivisonsData(isRefresh: true)
    }
    
    private func fetchSubDivisonsData(isRefresh: Bool){
        if isRefresh == false{
            startLoading("")
        }
        GDSManager().gethDivisonsOfGoup(groupId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async{
                    if isRefresh == false {
                        self?.finishLoading()
                    }else {
                        self?.refreshControl.endRefreshing()
                    }
                    if let subDivisonResponse = response{
                        if subDivisonResponse.success!{
                            self?.subDivisonlist = subDivisonResponse.data ?? []
                        }else{
                            self?.alertMessage(message:(self?.lang ?? "" == "en") ? subDivisonResponse.message?.en ?? "" : subDivisonResponse.message?.ar ?? "", completionHandler: nil)
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

extension VCSubDivisions: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subDivisonlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStores", for: indexPath) as! CellStores
        let subdivision = subDivisonlist[indexPath.row]
        cell.setupSubDivisonCell(subdivision)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let id = subDivisonlist[indexPath.row]._id{
           
            moveToStoreDetail(id)
        }
    }
    
    private func moveToStoreDetail(_ divisonid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
        vc.groupid = groupId
        vc.divisionid = divisonid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchSubDivisonsData(isRefresh: false)
    }
}


