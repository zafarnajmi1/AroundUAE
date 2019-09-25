//
//  VCPendingProducts.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCPendingProducts: BaseController,IndicatorInfoProvider {
    
    @IBOutlet var confirmedTableView: UITableView!{
        didSet{
            self.confirmedTableView.delegate = self
            self.confirmedTableView.dataSource = self
            self.confirmedTableView.alwaysBounceVertical = true
            self.confirmedTableView.addSubview(refreshControl)
        }
    }
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var ConfirmedOrderList = [OrderData]()
    var ConfirmedOrderSellerList = [SellerOrder]()
    var orderData:OrderData?
    var storeid = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(VCDilverdProducts.methodOfReceivedNotification(notification:)), name: Notification.Name("OrderShipped"), object: nil)
        
        fetchConfirmListData(isRefresh: false)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        fetchConfirmListData(isRefresh: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OrderShipped"), object: nil)
    }
    
    fileprivate func setupDelegates(){
        self.confirmedTableView.emptyDataSetSource = self
        self.confirmedTableView.emptyDataSetDelegate = self
        self.confirmedTableView.reloadData()
    }
    
    @objc func refreshTableView() {
        fetchConfirmListData(isRefresh: true)
    }
    
    private func fetchConfirmListData(isRefresh: Bool){
        if isRefresh == false{
            startLoading("")
        }
       
            OrderManager().ShowSellerAllCompleted(storeid, status: "confirmed",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        if isRefresh == false {
                            self?.finishLoading()
                        }else {
                            self?.refreshControl.endRefreshing()
                        }
                        
                        if let orderResponse = response{
                            if orderResponse.success!{
                                self?.ConfirmedOrderSellerList = orderResponse.data ?? []
                            }else{
                                if(self?.lang ?? "" == "en")
                                {
                                self?.alertMessage(message:(orderResponse.message?.en ?? "").localized, completionHandler: nil)
                                }else
                                {
                                     self?.alertMessage(message:(orderResponse.message?.ar ?? "").localized, completionHandler: nil)
                                }
                            }
                        }else{
                            if(self?.lang ?? "" == "en")
                            {
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                            }else{
                                self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                                
                            }}
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
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Confirmed".localized)
    }
}

extension VCPendingProducts: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfirmedOrderSellerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTabCell")  as! PendingTabCell
        cell.selectionStyle = .none
        cell.setupSellerCellData(order: ConfirmedOrderSellerList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToSellerOrderDetail(ConfirmedOrderSellerList[indexPath.row])
    }
    
    private func moveToSellerOrderDetail(_ sellerOrder:SellerOrder){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SellerOrderDetail") as! SellerOrderDetail
        vc.sellerOrder = sellerOrder
        vc.storeid = storeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToDetail(_ orderdetail:OrderData){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderDetail") as! VCOrderDetail
        vc.orderData = orderdetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchConfirmListData(isRefresh: false)
    }
}

extension VCPendingProducts: OrderProtocol{
    
    func orderEyetapped(cell: PendingTabCell) {
        let indexpath = confirmedTableView.indexPath(for: cell)!
        moveToSellerOrderDetail(ConfirmedOrderSellerList[indexpath.row])
    }
}
