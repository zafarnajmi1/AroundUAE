//
//  OrderDetail.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SocketIO

class VCOrderDetail: BaseController {

    @IBOutlet weak var lbltotalamount: UILabel!
    @IBOutlet weak var lblorder: UILabel!
    @IBOutlet weak var lblorderstatus: UILabel!
    @IBOutlet weak var lblorderTotalamount: UILabel!
    @IBOutlet weak var lblorderdate: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var ConfirmedOrderList = [SomeOrderDetails]()
    var orderData:OrderData?
    var isfromNotification:Bool?
    var orderid = ""
    var notificationid = ""
    var manager:SocketManager!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var socket:SocketIOClient!
    
    @IBOutlet var confirmedTableView: UITableView!{
        didSet{
            self.confirmedTableView.delegate = self
            self.confirmedTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isfromNotification ?? false{
            orderDetail(orderid: orderid)
            guard let userToken = AppSettings.sharedSettings.authToken else {return}
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forceWebsockets(true),
                .forcePolling(false),
                .path(socketPath),
                .connectParams(usertoken),
                .log(true)]
            self.manager = SocketManager(socketURL: URL(string:  socketURL)! , config: specs)
            self.socket = manager.defaultSocket
            self.manager.defaultSocket.on("connected") {data, ack in
                
            }
            self.socket.on("connected") { (data, ack) in
                self.seenArray()
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
            }
        }else{
            setupData()
            ConfirmedOrderList = orderData?.orderDetails ?? []
            confirmedTableView.reloadData()
        }
    }
    
    func seenArray() {
        var SeenArr = [String]()
        SeenArr.append(notificationid)
        let json2 = [
            "notifications": SeenArr
        ]
        
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("notificationsSeen", with: [json2])
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(lang == "en"){
            self.addBackButton()
        
        }else{
            self.showArabicBackButton()
        }
        self.lblorderdate.text = "Date".localized
        self.title = "Order Detail".localized
        self.lblorderstatus.text = "Status".localized
        self.lblorderTotalamount.text = "Total Products".localized
        self.lblorder.text = "Order".localized
        self.lbltotalamount.text = "Total Amount:".localized
    }
    
    private func setupData(){
         lblOrderNumber.text = "Order # \(orderData?.orderNumber ?? "")"
         lblAmount.text = "$\(orderData?.charges ?? 0.0)"
         var Confirmed = 0
         var Shipped = 0
         var Completed = 0
    
         for obj in orderData?.orderDetails! ?? []{
            if obj.status ?? "" == "shipped"{
                Shipped += 1
            }
            if obj.status ?? "" == "confirmed"{
                Confirmed += 1
            }
            if obj.status ?? "" == "completed"{
                Completed += 1
            }
         }
        
         lblStatus.text = "Confirmed(\(Confirmed)), "+"Shipped(\(Shipped)), "+"Completed(\(Completed)) "
         let dateFormatter = DateFormatter()
         let tempLocale = dateFormatter.locale
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
         let date = dateFormatter.date(from: orderData?.createdAt! ?? "")!
         dateFormatter.dateFormat = "d MMM, yyyy"
         dateFormatter.locale = tempLocale
         let dateString = dateFormatter.string(from: date)

         lblDate.text = dateString
         lblTotal.text = "\(orderData?.orderDetails?.count ?? 0)"
    }
}

extension VCOrderDetail:UITableViewDelegate,UITableViewDataSource,OrderDetailPrortocol{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfirmedOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell")  as! OrderDetailCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setupData(order: ConfirmedOrderList[indexPath.row])
        return cell
    }
    
    func tapOnReceived(cell:OrderDetailCell){
        let indexpath = confirmedTableView.indexPath(for: cell)
        makeProductComplete(orderid: ConfirmedOrderList[(indexpath?.row ?? 0)]._id ?? "")
    }
    
    private func orderDetail(orderid:String){
        startLoading("")
        OrderManager().orderDetail(orderid, successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let completedResponse = response{
                        if completedResponse.success!{
                           self?.orderData = completedResponse.data
                           self?.setupData()
                           self?.ConfirmedOrderList = self?.orderData?.orderDetails ?? []
                           self?.confirmedTableView.reloadData()
                        }else{
                            self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                                self?.navigationController?.popViewController(animated: true)
                            })
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func makeProductComplete(orderid:String){
        startLoading("")
        OrderManager().MakeProductComplete(orderid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let completedResponse = response{
                    if completedResponse.success!{
                        
                        self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            NotificationCenter.default.post(name: Notification.Name("OrderShipped"), object: nil)
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message:(self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}
