//
//  VCProductFilter.swift
//  AroundUAE
//
//  Created by Macbook on 18/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import DropDown
import MapKit

var isFromHome = false
class VCProductFilter: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var btnNearFar: UIButton!
    
    @IBOutlet weak var lblNearToFar: UILabel!
    @IBOutlet weak var txt_max: UITextField!
    @IBOutlet weak var txt_min: UITextField!
    var testgroupid = ""
    
   
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
   
    var location : [String] = []
    var checkLocation : Bool = false
    var skip = 0
    var totalPage = 0
    
     let menudropDown1 = DropDown()
     let nearfardropdown = DropDown()
    @IBOutlet weak var btnSearchclick: UIButtonMain!
    @IBOutlet weak var ViewRanger: RangeSlider!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var txtfiledEnterKeyword: UITextField!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectGroupBtn: UIButton!
    @IBOutlet weak var selectDivisionBtn: UIButton!
    @IBOutlet weak var selectSectionBtn: UIButton!
    @IBOutlet weak var selectManufacturesBtn: UIButton!
    
    @IBOutlet weak var selectGroupArrow: UIImageView!
    @IBOutlet weak var selectDivisionArrow: UIImageView!
    @IBOutlet weak var selectSectionArrow: UIImageView!
    @IBOutlet weak var selectManufacturesArrow: UIImageView!
    
    @IBOutlet weak var selectGrouplbl: UILabel!
    @IBOutlet weak var selectDivisionlbl: UILabel!
    @IBOutlet weak var selectSectionlbl: UILabel!
    @IBOutlet weak var selectManufactureslbl: UILabel!
    
    @IBOutlet weak var selectGroupHeader: UILabel!
    @IBOutlet weak var selectDivisionHeader: UILabel!
    @IBOutlet weak var selectSectionHeader: UILabel!
    @IBOutlet weak var selectManufacturesHeader: UILabel!
    
    @IBOutlet weak var searchBtnHeight: NSLayoutConstraint!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8039215686, green: 0.09411764706, blue: 0.2470588235, alpha: 1)
        return refreshControl
    }()
    
    
    
    var featuresArray = [Features]()
    var filterdata = [GroupDivisonData]()
    var filtersearchdata:FilterSeachData?
    var filterArray = [Int]()
    var max : String?
    var min : String?
    var max1 = ""
    var min1 = ""
    var counter = 0
    var groupIndex = 0
    var divisionIndex = 0
    var isDivisonShown = false
    var isSectionShown = false
    let dispatchGroup = DispatchGroup()
    var selectedGroupId:String?
    var selectedDivision: Divisions?
    var selectedSection:Sections?
    var selectedCharacterticts:String?
    var selectedManufactorId:String?
    var neartofar: String? = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        
        currentCordinate()
        txt_max.delegate = self
        txt_min.delegate = self
       btnNearFar.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnNearFar.layer.borderWidth = 0.5
        btnNearFar.layer.cornerRadius = 5
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
        getFilterSearcData()
        dispatchGroup.notify(queue: .main) {
            self.selectGroupBtn.isHidden = false
            self.selectGroupArrow.isHidden = false
            self.selectGrouplbl.isHidden = false
            self.btnSearchclick.isHidden = false
            //self.setViewHeight()
            self.finishLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        skip = 0
        
        self.title = "Search".localized
        
        self.setNavigationBar()
        if(lang == "en"){
            self.addBackButton()
        }else{
            self.showArabicBackButton()
        }
        lblNearToFar.text = "Near to Far".localized
        self.lblFilter.text = "Price Range".localized
        self.txtfiledEnterKeyword.placeholder = "Enter Keyword...".localized
        if(lang == "en"){
            txt_min.textAlignment = .left
            txt_max.textAlignment = .left
            self.txtfiledEnterKeyword.textAlignment = .left
        }else{
            txt_min.textAlignment = .right
            txt_max.textAlignment = .right
            self.txtfiledEnterKeyword.textAlignment = .right
        }
        txt_max.placeholder = "Max Price".localized
         txt_min.placeholder = "Min Price".localized
    }
    
    private func setViewHeight(){
        var tableViewHeight:CGFloat = 0;
        for i in 0..<self.filterTableView.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.filterTableView, heightForRowAt: IndexPath(row: i, section: 0))
        }
        filterTableConstraint.constant = tableViewHeight
        searchBtnHeight.constant = tableViewHeight + 280
        self.filterTableView.setNeedsDisplay()
    }
    
    private func divisionsetViewHeight(){
        var tableViewHeight:CGFloat = 0;
        for i in 0..<self.filterTableView.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.filterTableView, heightForRowAt: IndexPath(row: i, section: 0))
        }
        filterTableConstraint.constant = tableViewHeight
        self.filterTableView.setNeedsDisplay()
    }
    
    private func getFeaturesCharacters(divisionArray:[String], sectionArray:[String]){
        startLoading("")
        ProductManager().getFeaturesCharacters((divisionArray,sectionArray),
           successCallback: {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let filterResponse = response{
                    if filterResponse.success!{
                        self?.featuresArray = filterResponse.data?.features ?? []
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                    else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
         }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func getFilterSearchData(groupId:String, divisionId:String){
        startLoading("")
        IndexManager().getSearchFilterData((groupId,divisionId),
          successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let filterResponse = response{
                        if filterResponse.success!{
                            self?.filtersearchdata = filterResponse.data!
                            self?.searchBtnHeight.constant = 280
                            
                            self?.featuresArray.removeAll()
                            self?.filterTableView.reloadData()
                            self?.divisionsetViewHeight()
                            self?.scrollView.updateContentView()
                            self?.view.setNeedsDisplay()
                            self?.selectSectionlbl.text = "Select Section"
                            self?.selectSectionBtn.isHidden = false
                            self?.selectSectionlbl.isHidden = false
                            self?.selectSectionArrow.isHidden = false
                            self?.selectSectionHeader.isHidden = false
                            
                            self?.selectManufactureslbl.text = "Select Manufactures"
                            self?.selectManufacturesArrow.isHidden = false
                            self?.selectManufacturesBtn.isHidden = false
                            self?.selectManufactureslbl.isHidden = false
                            self?.selectManufacturesHeader.isHidden = false
                            self?.filterTableView.reloadData()
                            
                        }
                        else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func getFilterSearcData(){
        dispatchGroup.enter()
        GDSManager().getGroupsWithDivisons(successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.dispatchGroup.leave()
                    if let filterResponse = response{
                        if filterResponse.success!{
                            self?.filterdata = filterResponse.data ?? []
                            self?.filterTableView.reloadData()
                            self?.scrollView.updateContentView()
                        }
                        else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.dispatchGroup.leave()
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider){
        max = "\((rangeSlider.upperValue))"
        min = "\((rangeSlider.lowerValue))"
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_min {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let Range = range.length + range.location > (txt_min.text?.count)!
            
            if Range == false && alphabet == false {
                return false
            }
            
            let NewLength = (txt_min.text?.count)! + string.count - range.length
            return NewLength <= 6
        }else if textField == txt_max{
            
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let Range = range.length + range.location > (txt_max.text?.count)!
            
            if Range == false && alphabet == false {
                return false
            }
            
            let NewLength = (txt_max.text?.count)! + string.count - range.length
            return NewLength <= 10
        }
        return true
    }
    
    
    private func searchProducts(){
        
        if(txt_min.text?.count != 0 && txt_max.text?.count != 0){
            
            max = txt_max.text!
            min = txt_min.text!
            //min = Int(min1)!
            //max = Int(max1)!
        }else{
        if ViewRanger.maximumValue == 0.0{
            max = ""
        }
        
        if ViewRanger.minimumValue == 0.0{
            min = ""
            }
            
            
        }
    
        startLoading("")
        
        
//        if btnNearBy.isSelected == true {
//            print(SharedData.sharedUserInfo.lat)
//            location = [String(SharedData.sharedUserInfo.long),String(SharedData.sharedUserInfo.lat)]
//        }
        /*
         typealias SearchParams = (
         locale:String,
         minPrice:Double,
         maxPrice:Double,
         location:[String],
         key:String,
         manufacturers:[String],
         groups:[String],
         divisions:[String],
         sections:[String],
         characterisrics:[String]
         
         )
         */
        //filterdata[self.groupIndex]._id
        //https://www.projects.mytechnology.ae/around-uae/groups/divisions/Electronics/5b8e7b0d66595431ec453d0e/5b8e7c3366595431ec453d12/products
        //print([filterdata[-1]._id ?? ""])
        ProductManager().SearchProduct(("","\(skip)",min ?? "" ,max ?? "",location,txtfiledEnterKeyword.text ?? "",[selectedManufactorId ?? ""],[self.testgroupid ],[self.selectedDivision?._id ?? ""],[self.selectedSection?._id ?? ""],[self.selectedCharacterticts ?? ""], neartofar ?? "" ),
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let productsResponse = response{
                        if productsResponse.success!{
                            self?.moveToFilteredProducts(products: productsResponse.data?.products ?? [])
                            self?.skip = (productsResponse.data?.products?.count)!
                        }
                        else{
                            if(self?.lang ?? "" == "en")
                            {
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }else{
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }
                    }else{
                        if(self?.lang ?? "" == "en")
                        {
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
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
    
    private func moveToFilteredProducts(products:[Products]){
        if isFromHome{
            NotificationCenter.default.post(name: Notification.Name("SearchCompleted"), object: products)
            self.navigationController?.popViewController(animated: true)
        }else{
            
            
            
//            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
//            searchKeyword = txtfiledEnterKeyword.text!
//            vc.groupid = filterdata[self.groupIndex]._id ?? ""
//            vc.divisionid = self.selectedDivision?._id ?? ""
//            vc.sectionid = self.selectedSection?._id ?? ""
//            vc.manufactorid = selectedManufactorId ?? ""
//            vc.characteristicsid = self.selectedCharacterticts ?? ""
//            vc.lat = "\(SharedData.sharedUserInfo.lat!)"
//            vc.long = "\(SharedData.sharedUserInfo.long!)"
            
            
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            //let vc = storyboard.instantiateViewController(withIdentifier: "VCTopratedProductList") as! VCTopratedProductList
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
            searchKeyword = txtfiledEnterKeyword.text!
            vc.groupid = self.testgroupid  //filterdata[self.groupIndex]._id ?? ""
            vc.divisionid = self.selectedDivision?._id ?? ""
            print(self.selectedDivision?._id!)
            vc.sectionid = self.selectedSection?._id ?? ""
            vc.manufactorid = selectedManufactorId ?? ""
            vc.characteristicsid = self.selectedCharacterticts ?? ""
            
            vc.min = min
            vc.max = max
            vc.skip = self.skip
            vc.totalPage = self.totalPage
            vc.Location = location
            vc.neartofar = neartofar ?? ""
//            if btnNearBy.isSelected {
//                print(SharedData.sharedUserInfo.lat)
//                vc.Location = [String(SharedData.sharedUserInfo.long),String(SharedData.sharedUserInfo.lat)]
//            }
            
//            vc.Location = self.location
//            vc.lat = "\(SharedData.sharedUserInfo.lat!)"
//            vc.long = "\(SharedData.sharedUserInfo.long!)"
            
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSearch(_ sender: UIButton){
        searchProducts()
    }
    
    @objc func refreshTableView(){
        
        
        
    }

    
    @IBAction func btnNearForAction(_ sender: UIButton) {
        
//        if(self.lang == "ar"){
//            self.menudropDown1.customCellConfiguration = { (Index: Index, item: String, cell: DropDownCell) -> Void in
//                
//                cell.optionLabel.textAlignment = .right
//                
//            }
//            
//        }
        
        menudropDown1.anchorView = btnNearFar
        menudropDown1.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown1.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        var NearFar = ["Near to Far".localized,"Far to Near".localized]
        //NearFar.insert("Select Option".localized, at: 0)
        menudropDown1.dataSource = NearFar
        
        menudropDown1.selectionAction = {(index: Int, item: String) in
            
            if item == "Near to Far"{
                self.lblNearToFar.text = "Near to Far".localized
                self.neartofar = "true"
                self.location = [String(SharedData.sharedUserInfo.lat),String(SharedData.sharedUserInfo.long)]
                
            }else if item  == "Far to Near" {
                self.neartofar = "false"
                self.lblNearToFar.text = "Far to Near".localized
                self.location = [String(SharedData.sharedUserInfo.lat),String(SharedData.sharedUserInfo.long)]
            }else{
                self.neartofar  = ""
                self.lblNearToFar.text = "Select Option".localized
                self.location.removeAll()
            }
            
        }
        
        
        menudropDown1.show()
        
    }
    
    
    
    func currentCordinate()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()//requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("Location Manager Result arrived")
        
        let location = locations.last! as CLLocation
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
        SharedData.sharedUserInfo.lat = location.coordinate.latitude
        SharedData.sharedUserInfo.long = location.coordinate.longitude
    }
    
    
    
//    @IBAction func btnActionFarNEar(_ sender: UIButton) {
//
//        let menudropDown1 = DropDown()
//        menudropDown1.anchorView = sender
//        menudropDown1.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        menudropDown1.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        menudropDown1.dataSource = ["abc".localized,"cba".localized]
//        menudropDown1.selectionAction = {(index: Int, item: String) in
//            self.groupIndex = index - 1
//            self.lblFarAndNear.text = item
//        }
//
//        menudropDown1.show()
//    }
//
    
    
    
    
    
    @IBAction func groupSelection(_ sender: UIButton){
        
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if(lang == "en"){
            var groupsarray = (filterdata.map({$0.title?.en ?? ""}))
            groupsarray.insert("Select Group", at: 0)
            menudropDown.dataSource = groupsarray
        }else{
            var groupsarray = (filterdata.map({$0.title?.ar ?? ""}))
            groupsarray.insert("اختر مجموعة", at: 0)
             menudropDown.dataSource = groupsarray
        }
        
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.groupIndex = index - 1
            self.selectGrouplbl.text = item
            
            if item == "Select Group"{
                self.groupIndex =  -1
                self.searchBtnHeight.constant = 25
                self.view.setNeedsDisplay()
                
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                
                self.scrollView.updateContentView()
                
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
                
                self.selectDivisionBtn.isHidden = true
                self.selectDivisionlbl.isHidden = true
                self.selectDivisionArrow.isHidden = true
                self.selectDivisionHeader.isHidden = true
                
                self.selectedManufactorId = ""
                self.selectedDivision = nil
                self.selectedSection = nil
                self.selectedCharacterticts = ""
                
            }else{
                self.testgroupid = self.filterdata[self.groupIndex]._id ?? ""
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                
                self.scrollView.updateContentView()
                
                self.searchBtnHeight.constant = 100
                self.view.setNeedsDisplay()
                self.selectDivisionlbl.text = "Select Divison"
                
                self.selectDivisionBtn.isHidden = false
                self.selectDivisionlbl.isHidden = false
                self.selectDivisionArrow.isHidden = false
                self.selectDivisionHeader.isHidden = false
                
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
            }
        }
        menudropDown.show()
    }
    
    @IBAction func divisionSelection(_ sender: UIButton){
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if(lang == "en"){
            var divisionsarray = (filterdata[groupIndex].divisions?.map({$0.title?.en ?? ""})) ?? []
            divisionsarray.insert("Select Division", at: 0)
            menudropDown.dataSource = divisionsarray
        }else{
            var divisionsarray = (filterdata[groupIndex].divisions?.map({$0.title?.ar ?? ""})) ?? []
            divisionsarray.insert("Select Division", at: 0)
            menudropDown.dataSource = divisionsarray
        }
        
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.divisionIndex = index - 1
            self.selectDivisionlbl.text = item
            
            if item == "Select Division"{
                self.searchBtnHeight.constant = 100
                self.view.setNeedsDisplay()
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                self.scrollView.updateContentView()
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
                
                self.selectedManufactorId = ""
                self.selectedDivision = nil
                self.selectedSection = nil
                self.selectedCharacterticts = ""
            }else{
                self.selectedDivision = self.filterdata[self.groupIndex].divisions?[self.divisionIndex]
                self.getFilterSearchData(groupId: self.filterdata[self.groupIndex]._id ?? "", divisionId: self.filterdata[self.groupIndex].divisions?[self.divisionIndex]._id ?? "")
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionSelection(_ sender: UIButton){
        self.view.setNeedsDisplay()
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(lang == "en"){
            var sectionsarray = filtersearchdata?.division?.sections?.map({$0.title?.en ?? ""}) ?? []
            sectionsarray.insert("Select Section", at: 0)
            menudropDown.dataSource = sectionsarray
        }else{
            var sectionsarray = filtersearchdata?.division?.sections?.map({$0.title?.ar ?? ""}) ?? []
            sectionsarray.insert("Select Section", at: 0)
            menudropDown.dataSource = sectionsarray
        }
        menudropDown.selectionAction = {(index: Int, item: String) in
            if item == "Select Section"{
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.setViewHeight()
                self.selectSectionlbl.text = "Select Section".localized
                self.selectedManufactorId = ""
                self.selectedSection = nil
                self.selectedCharacterticts = ""
            }else{
                
                self.selectedSection = self.filtersearchdata?.division?.sections?[index - 1]
                self.selectSectionlbl.text = item
                self.getFeaturesCharacters(divisionArray: [self.selectedDivision?._id ?? ""], sectionArray: [self.selectedSection?._id ?? ""])
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionManufactures(_ sender: UIButton){
        self.view.setNeedsDisplay()
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(lang == "en"){
            var manufacturesarray = filtersearchdata?.division?.manufacturers?.map({$0.title?.en ?? ""}) ?? []
            manufacturesarray.insert("Select Manufactures", at: 0)
            menudropDown.dataSource = manufacturesarray
        }else{
            var manufacturesarray = filtersearchdata?.division?.manufacturers?.map({$0.title?.ar ?? ""}) ?? []
            manufacturesarray.insert("Select Manufactures", at: 0)
            menudropDown.dataSource = manufacturesarray
        }
        menudropDown.selectionAction = {(index: Int, item: String) in
            if item == "Select Manufactures"{
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.setViewHeight()
                self.selectManufactureslbl.text = "Select Manufactures".localized
                
                self.selectedCharacterticts = ""
            }else{
                self.selectManufactureslbl.text = item
                self.selectedManufactorId =
                    self.filtersearchdata?.division?.manufacturers?[index - 1]._id
            }
        }
        menudropDown.show()
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension VCProductFilter: UITableViewDelegate,UITableViewDataSource,featureCellProtocol{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! featureCell
        cell.delegate = self
        cell.menudropDown.anchorView = cell.backgroundBtn
        cell.menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.featureName.text = "Select".localized
        if(lang == "en"){
            cell.featureheader.text = featuresArray[indexPath.row].title?.en ?? ""
            var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""})) ?? []
            array.insert("Select".localized, at: 0)
            cell.menudropDown.dataSource = array
        }else
        {
            cell.featureheader.text = featuresArray[indexPath.row].title?.ar ?? ""
            var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.ar ?? ""})) ?? []
            array.insert("Select".localized, at: 0)
            cell.menudropDown.dataSource = array
        }
        cell.menudropDown.selectionAction = {(index: Int, item: String) in
            cell.featureName.text = item
            self.selectedCharacterticts = self.featuresArray[indexPath.row].characteristics?[index - 1]._id ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func didtap(cell:featureCell){
        cell.menudropDown.show()
    }
    
    private func addSelectedCell(){
        filterTableView.beginUpdates()
        filterTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        filterTableView.endUpdates()
    }
}

protocol featureCellProtocol  {
    func didtap(cell:featureCell)
}

class featureCell:UITableViewCell{
    
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var cellbackground: UIButtonMain!
    @IBOutlet weak var featureName: UILabel!
    @IBOutlet weak var featureheader: UILabel!
    var menudropDown = DropDown()
    var delegate:featureCellProtocol?
    
    @IBAction func didTap(_ sender: UIButton){
        delegate?.didtap(cell: self)
    }
}

extension UITextField{
    func txtfildborder(){
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3
        self.layer.borderColor =  #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
        self.clipsToBounds = true
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
