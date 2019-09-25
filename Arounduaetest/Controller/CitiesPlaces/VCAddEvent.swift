//
//  VCAddEvent.swift
//  Arounduaetest
//
//  Created by Apple on 17/04/2019.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

protocol  VCAddEventDelegate : class {
    func eventAdded(event : Event)
}

class VCAddEvent: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var txt_phoneNumber: UITextField!
    @IBOutlet weak var lblphonenumber: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_endDate: UITextField!
    @IBOutlet weak var txt_title : UITextField!
    @IBOutlet weak var txt_date : UITextField!
    @IBOutlet weak var txt_startTime : UITextField!
    @IBOutlet weak var txt_endTime : UITextField!
    @IBOutlet weak var txt_path : UITextField!
    @IBOutlet weak var txt_details : UITextView!
    
    @IBOutlet weak var btn_attach : UIButton!
    @IBOutlet weak var btn_addNow : UIButton!
    
    weak var delegate : VCAddEventDelegate!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var datePicker = UIDatePicker()
    var EnddatePicker = UIDatePicker()
    
    var startTime = UIDatePicker()
    var endTime = UIDatePicker()
    
    var str_date = ""
     var end_date = ""
    var str_startTime = ""
    var str_endTime = ""
    
    var image : UIImage!
    
    var cityID = ""
    var cityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_path.delegate = self
        txt_date.delegate = self
        txt_endDate.delegate = self
        txt_startTime.delegate = self
        txt_endTime.delegate = self
        navigationItem.title = "Add Event in \(cityName)"
        
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        
        EnddatePicker.minimumDate = Date()
        EnddatePicker.datePickerMode = .date
        
        startTime.datePickerMode = .time
        endTime.datePickerMode = .time
        
        datePicker.addTarget(self, action: #selector(pickerChnaged(_:)), for: UIControl.Event.valueChanged)
         EnddatePicker.addTarget(self, action: #selector(pickerChnaged(_:)), for: UIControl.Event.valueChanged)
        startTime.addTarget(self, action: #selector(pickerChnaged(_:)), for: UIControl.Event.valueChanged)
        endTime.addTarget(self, action: #selector(pickerChnaged(_:)), for: UIControl.Event.valueChanged)
        
        txt_details.layer.borderColor = UIColor.lightGray.cgColor
        txt_details.layer.borderWidth = 1.0
        txt_details.layer.cornerRadius = 5.0
        txt_details.clipsToBounds = true
        
        
        
        
        
        btn_addNow.layer.cornerRadius = 5.0
        btn_attach.layer.cornerRadius = 5.0
        
        
        txt_startTime.inputView = startTime
        txt_endTime.inputView = endTime
        txt_date.inputView = datePicker
        txt_endDate.inputView = EnddatePicker
        
        
        
        addBackButton(lang: lang!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Navigation
    @IBAction func onClick_add(sender : UIButton){
        if validateForm() {
            uploadEvent()
            
        }
    }
    @IBAction func onClick_attach(sender : UIButton){
        selectImagePickerSource()
    }
    func validateForm() -> Bool {
        var message = ""
        if txt_name.text?.count == 0 {
            message = "Please enter the name ".localized
        }else if txt_phoneNumber.text?.count == 0 {
            message = "Please enter the phone numner".localized
        }else if txt_Email.text?.count == 0 {
            message = "Please enter the email".localized
        } else if txt_title.text?.count == 0 {
            message = "Please enter title of event".localized
        }
        else if txt_date.text?.count == 0 {
            message = "Please enter Start date of event".localized
        }else if txt_endDate.text?.count == 0 {
            message = "Please enter end date of event".localized
        }
        else if txt_startTime.text?.count == 0 {
            message = "Please enter start time of event".localized
        }
        else if txt_endTime.text?.count == 0 {
            message = "Please enter end time of event".localized
        }
        else if image == nil {
            message = "Please select image for event".localized
        }
        else if txt_details.text?.count == 0 {
            message = "Please enter details of event".localized
        }
        if message == ""{
            return true
        }
        else{
            let alert = UIAlertController (title: "Alert!".localized, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) in
                
            }))
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    //Mark:- Network
    private func uploadEvent(){
        startLoading("")
        
        
//        typealias AddEventParams = (
//            cityID:String,
//            title:String,
//            description:String,
//            eventDate:String,
//            startTime : String,
//            endTime : String,
//            isActive : Bool
//        )
        let eventImageData = UIImageJPEGRepresentation(image,0.7)!
        CitiesPlacesManager().addEvent((cityID,txt_title.text!,txt_details.text!,str_date,str_startTime,str_endTime,"true",eventImageData, txt_name.text!, txt_Email.text!,txt_phoneNumber.text!, end_date),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let eventsResponse = response{
                        if(eventsResponse.success!){
                            
                            if let delegate = self?.delegate{
//                                let eventdetail = response?.data
//                                var event = Event()
//                                event._id = eventdetail?._id
//                                event.description = eventdetail?.description
//                                event.endTime = eventdetail?.endTime
//                                event.startTime = eventdetail?.startTime
//                                event.title = eventdetail?.startTime
//                                event.image = eventdetail?.image
//
//
//                                delegate.eventAdded(event: event)
                                UIApplication.shared.keyWindow!.makeToast("Your event is added successfully!")
                                self?.navigationController?.popViewController(animated: true)
                            }
//                            self?.eventsArray = eventsResponse.data?.events ?? []
//                            self?.currentPage = eventsResponse.data?.pagination?.page ?? 1
//                            self?.totalPages = eventsResponse.data?.pagination?.pages ?? 0
                        }
                        else
                        {
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

extension VCAddEvent : UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_path {
            selectImagePickerSource()
            return false
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == txt_date{
                pickerChnaged(datePicker)
            }else if textField == txt_endDate{
                pickerChnaged(EnddatePicker)
            }
            else if textField == txt_startTime{
                pickerChnaged(startTime)
            }
            else if textField == txt_endTime{
                pickerChnaged(endTime)
            }
        }
    }
}
extension VCAddEvent : UIImagePickerControllerDelegate {
    func selectImagePickerSource(){
        
        
//        imagePicker.mediaTypes =
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo".localized, style: .default, handler: { [weak self] (action) in
            self?.openImagePicekr(camera: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo".localized, style: .default, handler: { [weak self] (action) in
            self?.openImagePicekr(camera: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    func openImagePicekr(camera : Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = camera ? UIImagePickerController.SourceType.camera: UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true) {
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[.originalImage] as? UIImage
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            image = pickedImage
            txt_path.text = "root/Images/...jpg"
        }
        
        picker.dismiss(animated: true, completion: nil)

        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func pickerChnaged(_ picker : UIDatePicker){
        if picker == datePicker {
            print("Date :\(picker.date)")
            setEventDate(date: datePicker.date)
        }else if picker == EnddatePicker {
            print("Date :\(picker.date)")
            setEventEndDate(date: EnddatePicker.date)
        }
        else if picker == startTime {
            print("Date :\(startTime.date)")
            setEventStartTime(date: startTime.date)
        }
        else if picker == endTime {
            print("Date :\(endTime.date)")
            setEventEndTime(date: endTime.date)
        }
    }
    
    func setEventDate(date : Date){
        
        
        str_date = date.dateString(dateFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        txt_date.text = date.dateString(dateFormate: "d MMM yyyy")
//        let dateFormatter = DateFormatter()
////        let tempLocale = dateFormatter.locale
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//        str_date = dateFormatter.string(from: date)

//        txt_
        
        
//        return ""
    }
    
    
    func setEventEndDate(date : Date){
        
        
        end_date = date.dateString(dateFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        txt_endDate.text = date.dateString(dateFormate: "d MMM yyyy")
        //        let dateFormatter = DateFormatter()
        ////        let tempLocale = dateFormatter.locale
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //
        //        str_date = dateFormatter.string(from: date)
        
        //        txt_
        
        
        //        return ""
    }
    
    func setEventStartTime(date : Date){
        str_startTime =  date.dateStringForServer(dateFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") //dateString(date: date, dateFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        txt_startTime.text = date.dateString(dateFormate: "h:mm a")
    }
    func setEventEndTime(date : Date){
        str_endTime = date.dateStringForServer(dateFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        txt_endTime.text = date.dateString(dateFormate: "h:mm a")
    }
//    func dateString(date : Date, dateFormate : String) -> String{
//        let dateFormatter = DateFormatter()
//        //        let tempLocale = dateFormatter.locale
////        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = dateFormate//"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//        return  dateFormatter.string(from: date)
//
////        txt_
//
//
//        //        return ""
//    }
//    func timeString(Date : Date) -> String {
//        return ""
//    }
    
    
    
    
}

