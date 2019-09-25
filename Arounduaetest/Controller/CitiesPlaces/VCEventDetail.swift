//
//  VCEventDetail.swift
//  Arounduaetest
//
//  Created by Apple on 17/04/2019.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

class VCEventDetail: UIViewController {
    
    @IBOutlet weak var img_eventImage : UIImageView!
    @IBOutlet weak var lbl_date : UILabel!
    @IBOutlet weak var lbl_time : UILabel!
    @IBOutlet weak var lbl_title : UILabel!
    @IBOutlet weak var lbl_description : UILabel!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet weak var lblphone: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    var eventDetail : EventDetail!
    
    var eventID = ""
    var cityID = ""
    var cityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Event Detail"
        addBackButton(lang: lang!)
        fetchEventDetail()
        addRightButton(image: "Add", action: #selector(onClick_rightButton))

        // Do any additional setup after loading the view.
    }
    func loadUI(){
        if let eventDetail = eventDetail{
            img_eventImage.sd_setImage(with: URL(string: eventDetail.image!), placeholderImage: UIImage(named: "Category"))
            
            
            let startTime = Date.formatedDateFromString(date: eventDetail.startTime!, newFormate: "h:mm a")
            let endTime = Date.formatedDateFromString(date: eventDetail.endTime!, newFormate: "h:mm a")
            
            lbl_time.text = ("\(startTime) to \(endTime)")
            
            
            //lbl_date.text = Date.formatedDateFromString(date: eventDetail.endTime!, newFormate: "d MMM yyyy")
            
            
            let startDate = Date.formatedDateFromString(date: eventDetail.startTime!, newFormate: "d MMM yyyy")
            let endDate = Date.formatedDateFromString(date: eventDetail.endTime!, newFormate: "d MMM yyyy")
            lbl_date.text = ("\(startDate) to \(endDate)")
           
            lblusername.text = eventDetail.fullName
            lblemail.text = eventDetail.email
            lblphone.text = eventDetail.phone
            
//            lbl_date.text = eventDetail.eventDate
//            lbl_time.text = "\(eventDetail.startTime!) to \(eventDetail.endTime!)"
            lbl_description.text = eventDetail.description!
            lbl_title.text = eventDetail.title!
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func onClick_rightButton(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCAddEvent") as! VCAddEvent
        vc.cityID = cityID
        vc.cityName = cityName
//        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    // Mark: - Network Request
    private func fetchEventDetail(){
        startLoading("")
        
        CitiesPlacesManager().getEventDetail((eventID),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let eventsResponse = response{
                        if(eventsResponse.success!){
                            
                            self?.eventDetail = eventsResponse.data
                            
                            self?.loadUI()
//                            self?.eventsArray = eventsResponse.data?.events ?? []
//                            self?.currentPage = eventsResponse.data?.pagination?.page ?? 1
//                            self?.totalPages = eventsResponse.data?.pagination?.pages ?? 0
                        }
                        else{
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
//                    self?.tbl_events.reloadData()
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
