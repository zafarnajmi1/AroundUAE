//
//  VCEvents.swift
//  Arounduaetest
//
//  Created by Apple on 16/04/2019.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

class VCEvents: UIViewController {
    
    @IBOutlet weak var tbl_events : UITableView!
    @IBOutlet weak var txt_search : UITextField!
//        {
////        didSet{
////            self.txt_search.delegate = self
////        }
//    }
    let eventCellID = "EventCell"
    let loadMoreCell = "LoadMoreCell"
    
    var cityId = ""
    var cityName = ""
    
//    var CitiesArray = [Cities]()
    var totalPages = 0
    var currentPage = 0
    var nextPage = 1
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var eventsArray = [Event]()
    var reloadTable = false
    var refreshTable = false
    var loadMore = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Events in \(cityName)"
        txt_search.delegate = self
        txt_search.placeholder = "Search Events...".localized
        self.tbl_events.tableFooterView = UIView(frame: .zero)
        self.tbl_events.addSubview(refreshControl)
        tbl_events.register(UINib(nibName: eventCellID, bundle: nil), forCellReuseIdentifier: eventCellID)
        tbl_events.register(UINib(nibName: loadMoreCell, bundle: nil), forCellReuseIdentifier: loadMoreCell)
        
//        txt_search.addTarget(self, action: #selector(textChanged(textField:)), for: UIControl.Event.editingChanged)
        fetchEventsData(pageNo: String(nextPage))
        
        addRightButton(image: "Add", action: #selector(onClick_rightButton))
        addBackButton(lang : lang!)
//        addleftButton(image: "back")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if reloadTable {
            tbl_events.reloadData()
        }
    }
    @objc func onClick_rightButton(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCAddEvent") as! VCAddEvent
        vc.cityID = cityId
        vc.cityName = cityName
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Mark: - Network Request
    private func fetchEventsData(pageNo : String){
        
        if !refreshTable && pageNo == "1" {
            startLoading("")
        }
//        else{
//
//        }
        
        
        CitiesPlacesManager().getEvents((cityId,pageNo,txt_search.text ?? ""),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    
                    if self?.refreshTable ?? false {
                        self?.refreshControl.endRefreshing()
                        self?.refreshTable = false
                    }
                    else{
                        self?.finishLoading()
                    }
                    
                    if let eventsResponse = response{
                        if(eventsResponse.success!){
                            
                            
                            
                            
                            self?.currentPage = eventsResponse.data?.pagination?.page ?? 1
                            self?.nextPage = eventsResponse.data?.pagination?.next ?? 1
                            self?.totalPages = eventsResponse.data?.pagination?.pages ?? 1
                            
                            if (self?.currentPage)! > 1 {
                                
                                for event in (eventsResponse.data?.events)!{
                                    self?.eventsArray.append(event)
                                }
                                
//                                self?.eventsArray.appe = eventsResponse.data?.events ?? []
                            }
                            else{
                                self?.eventsArray = eventsResponse.data?.events ?? []
                            }
                            
                        }else{
                            if(self?.lang ?? "" == "en")
                            {
                                self?.alertMessage(message:(eventsResponse.message?.en ?? "").localized, completionHandler: nil)
                            }else
                            {
                                self?.alertMessage(message:(eventsResponse.message?.ar ?? "").localized, completionHandler: nil)
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
                    self?.tbl_events.reloadData()
//                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
//                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    

}
extension VCEvents : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventsArray.count == 0 {
            return 0
        }
        
        if currentPage == totalPages {
            return eventsArray.count
            
        }
        else {
            return eventsArray.count + 1
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == eventsArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadMoreCell) as! LoadMoreCell
            cell.ai_loading.startAnimating()
            loadMoreData()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellID) as! EventCell
        let event = eventsArray[indexPath.row]
        cell.loadCell(object: event)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == eventsArray.count {
            return
        }
        
        let event = eventsArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCEventDetail") as! VCEventDetail
        vc.eventID = event._id ?? ""
        vc.cityName = cityName
        vc.cityID = cityId
        navigationController?.pushViewController(vc, animated: true)
    }
    func loadMoreData(){
        if !loadMore {
            loadMore = true
            fetchEventsData(pageNo: String(nextPage))
        }
    }
    @objc func refreshTableView() {
        refreshTable = true
        currentPage = 0
        totalPages = -1
        nextPage = 1
        fetchEventsData(pageNo: String(nextPage))
        
//        fetchConfirmListData(isRefresh: true)
    }
    
    
}
extension VCEvents : UITextFieldDelegate {
    @objc func textChanged(textField : UITextField){
        currentPage = 1
        totalPages = -1
        nextPage = 1
        fetchEventsData(pageNo: String(nextPage))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentPage = 1
        totalPages = -1
        nextPage = 1
        fetchEventsData(pageNo: String(nextPage))
        return true
    }
    
}
extension VCEvents : VCAddEventDelegate {
    func eventAdded(event: Event) {
        eventsArray.insert(event, at: 0)
        reloadTable = true
    }
    
    
}
