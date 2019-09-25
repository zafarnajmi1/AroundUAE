//
//  VCHomeTab.swift
//  AroundUAE
//
//  Created by Macbook on 13/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SocketIO
import SwiftyJSON
import MIBadgeButton_Swift
var cartCount = ""

class VCHomeTabs: TTabBarViewController {
    
    var Notificationbtn: MIBadgeButton?
    var Cartbtn: MIBadgeButton?
    var Count = ""
    var manager:SocketManager!
    var socket:SocketIOClient!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.title = "Around UAE".localized
        if AppSettings.sharedSettings.user.accountType == "seller"{
            viewControllers?.remove(at: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.rightBarButton()
        setsocketIOS()
        if AppSettings.sharedSettings.user.accountType == "buyer"{
            getCartProducts()
        }
    }
    
    private func getCartProducts(){
        CartManager().getCartProducts(
            successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if let cartProductData = response{
                        if cartProductData.success!{
                            cartCount = String(Int((cartProductData.data ?? []).map({$0.quantity ?? 0.0}).reduce(0, +)))
                            self?.rightBarButton()
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }

    @objc func btnCardClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCCart") as! VCCart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSearchClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProductFilter") as! VCProductFilter
        isFromHome = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButton() {
        if AppSettings.sharedSettings.user.accountType == "buyer"{
            Cartbtn = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            Cartbtn?.badgeBackgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            Cartbtn!.setImage(UIImage(named: "Cart"), for: .normal)
            if(cartCount == ""){
                Cartbtn?.badgeString = nil
            }
            else if (cartCount == "0"){
                Cartbtn?.badgeString = nil
            }
            else{
                Cartbtn?.badgeString = cartCount
            }
            
            Cartbtn?.addTarget(self, action:#selector(btnCardClick(_:)), for: UIControlEvents.touchUpInside)
        }

        Notificationbtn = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        Notificationbtn?.badgeBackgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        Notificationbtn!.setImage(#imageLiteral(resourceName: "Notification-red"), for: .normal)
    
        if(Count == ""){
            Notificationbtn?.badgeString = nil
        }
        else if (Count == "0"){
            Notificationbtn?.badgeString = nil
        }
        else{
            Notificationbtn?.badgeString = Count
        }
        
       
        Notificationbtn?.addTarget(self, action:#selector(VCHomeTabs.notification_message), for: UIControlEvents.touchUpInside)
        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
        Notificationbtn!.badgeEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        
        //self.navigationItem.rightBarButtonItems = [notificationItem]
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "Search"), for: .normal)
        btn2.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        btn2.addTarget(self, action: #selector(btnSearchClick(_:)), for: .touchUpInside)
        let btnSearch = UIBarButtonItem(customView: btn2)
        
        if let btn = Cartbtn {
            let cartItem = UIBarButtonItem(customView:btn)
            Cartbtn!.badgeEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        self.navigationItem.setRightBarButtonItems([btnSearch,cartItem,notificationItem], animated: true)
        }else{
            self.navigationItem.setRightBarButtonItems([btnSearch,notificationItem], animated: true)
        }
    }
    
    @objc func notification_message(_ sender: Any){
        moveToNotificationVC()
    }
    
    private func moveToNotificationVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setsocketIOS(){

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
            print(data)
        }
        
        
        self.socket.on("connected") { (data, ack) in
            if let arr = data as? [[String: Any]] {
                if let txt = arr[0]["text"] as? String {
                    print(txt)
                }
            }
        }
        
        self.socket.on("unseenNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            let NotificationCount = NotificationCountModel.init(dictionary: dictionary as NSDictionary)
            
            if(NotificationCount?.success)!{
                self.Count = "\(String(describing: NotificationCount!.data!.unseenNotificationsCount!))"
                self.rightBarButton()
            }
        }
        
        self.socket.on("newNotification") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.socket.emit("unseenNotifications")
            
        }
   
        self.socket.on(clientEvent: .connect) {data, emitter in
            // handle connected
            
            self.socket.emit("unseenNotifications")
          
        }
        
        self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
            //handle diconnect
        })
        
        self.socket.onAny({ (event) in
            //handle event
        })
        
        self.socket.connect()
        // CFRunLoopRun()
        
        // Do any additional setup after loading the view.
        
    }
}
