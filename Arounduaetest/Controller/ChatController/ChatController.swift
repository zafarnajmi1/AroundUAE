//
//  ChatController.swift
//  HelloStream
//
//  Created by iOSDev on 6/22/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SocketIO
import IQKeyboardManagerSwift

class ChatController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var tableView: UITableView! {
        didSet {
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet var backViewTextFields: UIView!
    @IBOutlet var buttonAttach: UIButton! {
        didSet {
            buttonAttach.tintColor = UIColor(red: 251/255, green: 31/255, blue: 72/255, alpha: 1.0)
        }
    }
    @IBOutlet var txtMessage: UITextField! {
        didSet {
            txtMessage.delegate = self
            txtMessage.backgroundColor = UIColor.white
            txtMessage.clipsToBounds = true
            txtMessage.layer.masksToBounds = true
            //txtMessage.layer.cornerRadius = 12
           // txtMessage.layer.borderWidth = 2
            //txtMessage.layer.borderColor = UIColor.clear.cgColor
            let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            txtMessage.leftView = paddingView
            let lang = UserDefaults.standard.string(forKey: "i18n_language")
            if lang == "ar" {
                txtMessage.rightViewMode = .always
            }
            else if lang == "en" {
                txtMessage.leftViewMode = .always
            }
        }
    }
    @IBOutlet var buttonSmiley: UIButton!
    @IBOutlet var buttonSendMessage: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    //MARK:- properties
 //   var conversation_id = 0
    let user = SharedData.sharedUserInfo

    var dataArray = [Messages]()
    var salon_type = 5
    var isFromInfo = false
    var imageSizebytes = 0;
    var salonType = 0
    var imagePicker = UIImagePickerController()
    let fileName = "attachment"
    var imageUrl : URL!
    var selectedImage: UIImage!
    var screenTitle : String!
    var keyboardhide = false

    //MARK:- Application Life Cycle
    var manager:SocketManager!
    var socket:SocketIOClient!
    var Page = 1
    var TotalPage = 0;
    var ObjPage = 0;
    var fetchingMore = false
    var notificationid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.user.username
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
         self.setupKeyboardScrolling()
       // self.hideKeyboard()
        
        self.showData()
        self.txtMessage.leftViewRect(forBounds: CGRect(x: 50, y: 0, width: 0, height: 0))
        self.getAllmessages()
    }
    
    func seenArray() {
        var SeenArr = [String]()
        SeenArr.append(notificationid)
        let json2 = [
            "notifications": SeenArr
        ]
        print(json2)
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("notificationsSeen", with: [json2])
        }
    }
    
    func getTimeFromTimeStamp(timeStamp : Double) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let currentDate = Date()
        let second = currentDate.secondsInBetweenDate(date)
        let minutes : Int = Int(second/60)
        let hours : Int = Int(second/3600)
        let days  : Int = Int(second/(3600 * 24))
        
        if (days > 0 && days < 31)
        {
            return String(days) + " days ago"
        }
        
        if(hours > 0 && hours < 25)
        {
            return String(hours) + " hours ago"
        }
        if(minutes > 0 && minutes < 60)
        {
            return String(minutes) + " minutes ago"
        }
        
        if(second > 5 && second < 60)
        {
            let sec : Int = Int(round(second))
            return String(sec) + " second ago"
        }
        if(second <= 5)
        {
            return "just now".localized;
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        if lang == "ar" {
            showArabicBackButton()
            
        }else if lang == "en" {
            addBackButton()
        }
      
        
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        self.bottomConstraint.constant = 0;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // animateViewMoving(up: false, moveValue: 8)
        self.bottomConstraint.constant = 0
        //        self.tableView.contentInset.bottom = 0
        //        self.tableView.scrollIndicatorInsets.bottom = 0
        self.txtMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.bottomConstraint.constant = 0
        //        self.tableView.contentInset.bottom = 0
        //        self.tableView.scrollIndicatorInsets.bottom = 0
        self.txtMessage.resignFirstResponder()
        return true
    }
    
    // MARK: - KEYBOARD SCROLLING
    private var keyboard: Keyboard!
    
    private func setupKeyboardScrolling() {
        self.keyboard = Keyboard()
        
        // Lift/lower send view based on keyboard height.
        let keyboardAnimation = { [unowned self] in
            
            self.keyboardhide = true
            var keyboardHeight = self.keyboard.height
            if #available(iOS 11.0, *) {
                let bottomInset = self.view.safeAreaInsets.bottom
                keyboardHeight -= bottomInset
            }
            // self.backViewTextFields.isHidden = true
            self.bottomConstraint.constant  = keyboardHeight
            //self.isKeyboardOpened2 = false
            //  self.bottomConstraint.constant = self.keyboard.height
            self.view.layoutIfNeeded()
        }
        // Scroll to bottom after animation.
        let keyboardCompletion: (Bool) -> Void = { [unowned self] _ in
            self.scrollToBottom(animated: true)
            
            //self.isKeyboardOpened2 = false
            
        }
        
        // React to keyboard height changes.
        self.keyboard.heightChanged = {
            UIView.animate(
                withDuration: 0.2,
                animations: keyboardAnimation,
                completion: keyboardCompletion
            )
        }
        
        // Hide keyboard on tap.
        let tap =
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.hideKeyboard(_:))
        )
        self.tableView.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        //  self.sendView?.removeFocus()
        view.endEditing(true)
        if(self.keyboardhide){
            
            
            if #available(iOS 11.0, *) {
                let bottomInset = self.view.safeAreaInsets.bottom
                
                self.bottomConstraint.constant  += bottomInset
                self.keyboardhide = false
            }
        }
        
        
        
        
    }
    
    
    private func scrollToBottom(animated: Bool) {
        
        if self.dataArray.count > 0 {
            let lastRow = IndexPath(row: self.dataArray.count - 1 , section: 0)
            self.tableView.scrollToRow(at: lastRow, at: .top, animated: animated)
        }
    }
    
    //MARK: - Custom
    
    func showLoader(){
      startLoading("")
    }
    
    
    
    func showData () {
//        let data = UserDefaults.standard.value(forKey: "user")
//        let obj = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
//
//        let model = UserModel(fromDictionary: obj as! [String: Any])
//        if let salon = model.data.isSaloon {
//            print("salon type \(salon)")
//            self.salonType = salon
//        }
    }
    
    
    //MARK:- Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objChat = dataArray[indexPath.row]
        
        var sender = ""
        if(self.user.conversationArray.isEmpty){
            if(AppSettings.sharedSettings.accountType ==  "buyer"){

             sender = "user"
            }
            else{
                 sender = "store"
            
            }
        }
        else{
            if(AppSettings.sharedSettings.accountType ==  "buyer"){

                sender = "user"
            }
            else{
                sender = "store"
                
            }
        }
        
            if objChat.sender == sender
            {
                if (objChat.mimeType == "image/jpeg" ||   objChat.mimeType == "image/png")
                {
                    let cell : ReceiverImageCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as!  ReceiverImageCell
                    
                    cell.receiverImage.sd_addActivityIndicator()
                    cell.receiverImage.sd_setIndicatorStyle(.gray)
                    cell.receiverImage.sd_setImage(with: URL(string:objChat.content!) , completed: nil)
                  //  cell.receiverImageTime.text = self.getTimeFromTimeStamp(timeStamp: objChat.createdAt)
                    if let time = objChat.createdAt {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone

                        let date = dateFormatter.date(from: time)
                        print(date!)
                        
                        let millieseconds = date!.timeIntervalSince1970
                        
                        
                        print(millieseconds)
                        
                        
                        cell.receiverImageTime.text =  self.getTimeFromTimeStamp(timeStamp: Double(millieseconds))
                    }
                    cell.updateConstraintsIfNeeded()
                    return cell;
                }
                else
                {
                    let cell : ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                    cell.receiverMessage.text = objChat.content
                    if let time = objChat.createdAt {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone

                        let date = dateFormatter.date(from: time)
                        print(date!)
                        
                        let millieseconds = date!.timeIntervalSince1970
                        
                        
                        print(millieseconds)
                        
                        
                         cell.receiverTime.text =  self.getTimeFromTimeStamp(timeStamp: Double(millieseconds))
                    }
                 //   cell.receiverTime.text = self.getTimeFromTimeStamp(timeStamp: objChat.createdAt)
                    cell.updateConstraintsIfNeeded()
                    return cell;
                }
            }
            else
            {
                if (objChat.mimeType == "image/jpeg" ||   objChat.mimeType == "image/png")
                {
                    let cell : SenderImageCell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                    cell.senderImage.sd_addActivityIndicator()
                    cell.senderImage.sd_setIndicatorStyle(.gray)
                    cell.senderImage.sd_setImage(with: URL(string:objChat.content!), completed: nil)
                    if let time = objChat.createdAt {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone

                        let date = dateFormatter.date(from: time)
                        print(date!)
                        
                        let millieseconds = date!.timeIntervalSince1970
                        
                        
                        print(millieseconds)
                        
                        
                       cell.senderImageTime.text =  self.getTimeFromTimeStamp(timeStamp: Double(millieseconds))
                    }
              
                    cell.updateConstraintsIfNeeded()
                    return cell;
                }
                else
                {
                    let cell: SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                    cell.senderMessage.text = objChat.content
                //    cell.senderTime.text = self.getTimeFromTimeStamp(timeStamp: objChat.createdAt)
                    if let time = objChat.createdAt {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone

                        let date = dateFormatter.date(from: time)
                        print(date!)
                        
                        let millieseconds = date!.timeIntervalSince1970
                        
                        
                        print(millieseconds)
                        
                       cell.imgProfile.sd_addActivityIndicator()
                       cell.imgProfile.sd_setIndicatorStyle(.gray)
                       cell.imgProfile.sd_setImage(with: URL(string:self.user.conversationIDImage), completed: nil)
                       cell.senderTime.text =  self.getTimeFromTimeStamp(timeStamp: Double(millieseconds))
                    }
                    cell.updateConstraintsIfNeeded()
                    return cell;
                }
            }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHieght = scrollView.contentSize.height
        
        if offSetY > contentHieght - scrollView.frame.height {
            if !fetchingMore
            {
                beginBatchFetch()
            }
            
        }
        
        
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        print(self.ObjPage)
        print(self.TotalPage)
        
        if (self.ObjPage) < (self.TotalPage) {
            self.showLoader()
            Page += 1
            let conversationsList = [
                "conversation":  self.user.conversationID,
                "page": Page
                
                ] as [String : Any]
            
            self.socket.emit("messagesList", with: [conversationsList])
            
            
            
        }
        
    }
    
    
    
    @IBAction func onClickAttachButton(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: "Profile Picture".localized, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) {
            UIAlertAction in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Library".localized, style: .default) { (action) in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickSmileyButton(_ sender: UIButton) {
        print("Smile")
    }
    
    @IBAction func onClickSendMessageButton(_ sender: UIButton) {
        
        guard let msg = txtMessage.text else {
            return
        }
        if msg.characters.count == 0 {
//            let alert = // Constants.showBasicAlert(message: "Write something to send".localized)
//            self.presentVC(alert)
            self.alertMessage(message: "Write something to send".localized, completionHandler: nil)
        }
        else {
            //            if isFromInfo == true {
//            let parameter : [String: Any] = [
//                "conversation_id" : conversation_id,
//                "message" : msg
//            ]
            //print(parameter)
            
            let conversationID = [
                "conversation":  self.user.conversationID,
                 "content" : msg
            ]
           
                // handle connected
                
                
                self.socket.emit("sendMessage", with: [conversationID])
                
//            let conversationID2 = [
//                "conversation":  self.user.conversationID
//            ]
//              self.socket.emit("messagesList", with: [conversationID2])
         
            txtMessage.text=""
         
            self.viewDidLayoutSubviews()
            //     }
            //            else  {
            //                let parameter : [String: Any] = [
            //                    "conversation_id" : conversation_id,
            //                    "message" : msg
            //                ]
            //                print(parameter)
            //                self.sendMessage(parameter: parameter as NSDictionary)
            //            }
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Camera not Available".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("Not Available")
        }
    }
    

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    func createChunks() {
        
      
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            let imgData: NSData = NSData(data: UIImageJPEGRepresentation((pickedImage), 1)!)
            
            
            let imageSize: Int = imgData.length
            print("size of image in B: %f ", Double(imageSize) )
            //   readString(length:imageSize)
            
            print(imgData as Data)
            
            
            self.saveFileToDocumentDirectory(image: pickedImage)
            
            showLoader()
            let imageDataforSever = [
                "name":   "test.png",
                "size" : Double(imageSize)
                ] as [String : Any]
            
            
            print(imageDataforSever)
            self.socket.emit("startFileUpload", with: [imageDataforSever])
            self.socket.on("startUpload") { (data, ack) in
                
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
            }
            
            let imageData = imgData as Data
            let uploadChunkSize = 102400
            //   let uploadChunkSize = 5
            let totalSize = imageData.count
            var offset = 0
            self.socket.on("moreData") { (data, ack) in
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                let moreData = MoreData.init(dictionary: dictionary as NSDictionary)
                print(dictionary)
                
                
                let imageData = imgData as Data
                imageData.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                    let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                    
                    print(totalSize)
                    // while offset < totalSize {
                    
                    let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                    let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                    offset += chunkSize
                    //  let b1 = String(uploadChunkSize, radix: 2)
                    //    if let string = String(data: chunk.base64EncodedData(), encoding: .utf8) {
                    //  if let str = String(data: chunk, encoding: String.Encoding.utf8) {
                    
                    let chunkSize2 = chunk.count
                    
                    
                    
                    let imageDataupload = [
                        "name":   "test.png",
                        "data" : chunk as NSData ,
                        "pointer" : moreData!.data!.pointer! ,
                        "chunkSize" : chunkSize2
                        ] as [String : Any]
                    
                    print(imageDataupload)
                    
                    self.socket.emit("uploadChunk", with: [imageDataupload])
                    
                    
                    
                    
                    // }
                    
                    //  }
                }
            }
            
            self.socket.on("uploadCompleted") { (data, ack) in
                
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                let chat = CompleteChat.init(dictionary: dictionary as NSDictionary)
                print(dictionary)
                
                let conversationID = [
                    "conversation":  self.user.conversationID,
                    "type" : "image/jpeg",
                   
                    "fileName" : chat?.data?.fileName!
                    ] as [String : Any]
                
                self.socket.emit("sendMessage", with: [conversationID])
                
                
                
                
            }
            
            
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveFileToDocumentDirectory(image: UIImage) {
        
        if let savedUrl = FileManager.default.saveFileToDocumentsDirectory(image: image, name: self.fileName, extention: ".png") {
            self.imageUrl = savedUrl
        }
    }
    
    func removeFileFromDocumentsDirectory(fileUrl: URL) {
        _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
    }
    
    //MARK:- API Call
   
    
    func getAllmessages() {

        showLoader()
        
        if let userToken = AppSettings.sharedSettings.authToken {
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forcePolling(false),
                .forceWebsockets(true),
                .path(socketPath),
                .connectParams(usertoken),
                .log(true)
            ]
            //https://www.projects.mytechnology.ae/around-uae/
            self.manager = SocketManager(socketURL: URL(string:socketURL)! , config: specs)
        
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
            self.socket.on("newConversation") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                let Conversation = NewConversation.init(dictionary: dictionary as NSDictionary)
                
                self.user.conversationID = (Conversation?.data?.conversation?._id!)!
                print( self.user.conversationID)
                let conversationID = [
                    //  "conversation":  self.user.conversationID
                    "conversation":  self.user.conversationID,
                     "page": self.Page
                    
                    ] as [String : Any]
                
                self.socket.emit("messagesList", with: [conversationID])
                
            }
            
            self.socket.on("getConversation") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                let Conversation = NewConversation.init(dictionary: dictionary as NSDictionary)

                self.user.conversationID = (Conversation?.data?.conversation?._id!)!
                self.user.personID = (Conversation?.data?.conversation?.user?._id!)!
                self.user.chatTitle = (Conversation?.data?.conversation?.user?.fullName!)!

                print( self.user.conversationID)
                let conversationID = [
                    //  "conversation":  self.user.conversationID
                    "conversation":  self.user.conversationID,
                     "page": self.Page

                    ] as [String : Any]

                self.socket.emit("messagesList", with: [conversationID])
                
            }
            self.socket.on("messagesList") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                let Conversation = ChatModel.init(dictionary: dictionary as NSDictionary)
                
                
                self.dataArray +=  (Conversation?.data?.messages ?? [])
                
                self.TotalPage = (Conversation?.data?.pagination?.pages ?? 0)
                print(self.TotalPage)
                self.ObjPage =  (Conversation?.data?.pagination?.page ?? 0)
                self.fetchingMore = false
                
                
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                self.tableView.reloadData()
                if( self.dataArray.count == 0) {
                    
                }
                else{
                    
                    print(self.user.conversationArray.count)
                    if(self.user.conversationArray.isEmpty){
                        
                    }else{
                        if(self.user.conversationArray[self.user.conversationTableId].user?._id==AppSettings.sharedSettings.user._id!){
                            
                            self.screenTitle =  self.user.conversationArray[self.user.conversationTableId].store?.storeName?.en
                            if(self.screenTitle == nil || self.screenTitle == "")
                            {
                                self.title = "Chat".localized
                            }
                            else
                            {
                                self.title = self.screenTitle;
                            }
                        }
                        else{
                          self.screenTitle =  self.user.conversationArray[self.user.conversationTableId].user?.fullName
                            if(self.screenTitle == nil || self.screenTitle == "")
                            {
                                self.title = "Chat".localized
                            }
                            else
                            {
                                self.title = self.screenTitle;
                            }
                        }
                    }

                    
            
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: false)
                    
                }
                
                
                self.stopAnimating()
                
            }
           
            
          
            self.socket.on("conversationsList") { (data, ack) in
                let conversationID = [
                    "conversation":  self.user.conversationID,
                    "page": self.Page
                    
                    ] as [String : Any]
                print(conversationID)
                self.socket.emit("messagesList", with: [conversationID])
            }
            self.socket.on("newMessage") { (data, ack) in
            
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print( dictionary)
                
                let objData = NewMessageModel.init(dictionary: dictionary as NSDictionary)
                
            //    print(objData?.data!.data_new_message!)
                if(objData?.data!.data_new_message! != nil)
                {
                    self.dataArray.append((objData?.data!.data_new_message!)!)

                    if self.dataArray.count > 0
                    {
                        self.tableView.reloadData()
                     //   self.updateTableContentInset()
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: false)
                    }

                }
                
                
                let conversationID = [
                    "conversation":  self.user.conversationID
                    //  "page":  2
                    
                    ] as [String : Any]
                    print(conversationID)
              //  self.socket.emit("messagesList", with: [conversationID])
            }
         
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
           
            self.seenArray()
                if(self.user.conversationuserID == ""){
                    let conversationID = [
                        "conversation":  self.user.conversationID,
                          "page": self.Page

                        ] as [String : Any]
                    self.socket.emit("messagesList", with: [conversationID])

                }
                else{
                    let userID = [
                        "store":  self.user.conversationuserID
                        
                        ] as [String : Any]
                print(userID)
                    self.socket.emit("getConversation", with: [userID])

                }
                
            }
            
            self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
                //handle diconnect
            })
            
            self.socket.onAny({ (event) in
                //handle event
            })
            
            self.socket.connect()
            self.finishLoading()
        }
    }
}


class SenderCell: UITableViewCell {
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var message: UITextView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet weak var senderMessage: UILabel!
    @IBOutlet weak var senderTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class ReceiverCell : UITableViewCell {
    
    @IBOutlet var message: UITextView!
    @IBOutlet var imgBackground: UIImageView!
    
    @IBOutlet weak var receiverMessage: UILabel!
    @IBOutlet weak var receiverTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

class SenderImageCell : UITableViewCell
{
    @IBOutlet weak var senderImage : UIImageView!
    @IBOutlet weak var senderImageTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class ReceiverImageCell : UITableViewCell
{
    @IBOutlet weak var receiverImage : UIImageView!
    @IBOutlet weak var receiverImageTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}


