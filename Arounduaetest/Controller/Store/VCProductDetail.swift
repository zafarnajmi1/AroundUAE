//
//  VCProductDetail.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import MIBadgeButton_Swift
protocol reloaddata {
    func reloadDataorCart()
}
class VCProductDetail: UIViewController {

    @IBOutlet weak var btnstore: UIButton!
    @IBOutlet weak var tableviewReeviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var prodcutPrice: UILabel!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var Productcounter: GMStepperCart!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var favouritImage: UIImageView!
    var delegate: reloaddata?
    @IBOutlet weak var CollectionView: UICollectionView!{
        didSet{
            CollectionView.delegate = self
            CollectionView.dataSource = self
            CollectionView.allowsSelection = true
            CollectionView.allowsMultipleSelection = true
        }
    }
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    var product:Products!
   
    var Count = ""
    var productDetail:Product?
    var selectedCell = [IndexPath]()
    var features = [String]()
    var characteristics = [String]()
    var combination:Combinations?
    var dictionary:[String:Any]?
    var Notificationbtn: MIBadgeButton?
    
    var productIdCart : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(productIdCart != ""){
            getProductDetail(productid:productIdCart)
        }else{
            getProductDetail(productid: product._id!)
        }
    }
    
    override func viewDidLayoutSubviews(){
        super.updateViewConstraints()
        collectionViewHeight.constant = CollectionView.contentSize.height
        scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollview.contentSize.height)
    }
    
    private func setViewHeight(){
        var tableViewHeight:CGFloat = 0;
        for i in 0..<self.tableViewReviews.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.tableViewReviews, heightForRowAt: IndexPath(row: i, section: 0))
        }
        tableviewReeviewConstraint.constant = tableViewHeight + 20
        self.tableViewReviews.setNeedsDisplay()
    }
    
    @IBAction func share(_ sender:UIButton){
        let text = "http://216.200.116.25/around-uae/"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func getProductDetail(productid: String){
        startLoading("")
        ProductManager().productDetail(productid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.productDetail = storeResponse.data!
                        print(self?.productDetail?.store?._id)
                        self?.setupProductDetsil(storeResponse.data!)
                        self?.CollectionView.reloadData()
                        self?.tableViewReviews.reloadData()
                        self?.setViewHeight()
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "" , completionHandler: nil)
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
    
    private func checKCombination(){
        
        var dic = [String:Any]()
        dic["product"] = productDetail!._id!
        dic["quantity"] = "\(Int(Productcounter.value))"
        
        if productDetail?.hasCombinations ?? false{
            
            if features.count == 0 || characteristics.count == 0{
                self.alertMessage(message: "Please Select Some Combination or Feature...".localized, completionHandler: nil)
                return
            }
            
            guard let comb = combination,
                let avaliablecount = comb.avalaible,avaliablecount > Int(Productcounter.value) else{
                    self.alertMessage(message: "Product is not avaliable in your desired quantity".localized, completionHandler: nil)
                    return
            }
            
            if let combinations = productDetail?.combinations{
                for obj in combinations{
                    if obj.features! != features || obj.characteristics! != characteristics {
                        self.alertMessage(message: "Could not find combination!!", completionHandler: nil)
                    }else if obj.features! == features && obj.characteristics! == characteristics{
                        prodcutPrice.text = (lang == "en") ? "$\(obj.price?.usd ?? 0)" : "$\(obj.price?.aed ?? 0)"
                        combination = obj
                        dictionary = dic
                        break
                    }
                }
            }
        }else{
            dictionary = dic
        }
    }
    
    
    @IBAction func btnStoreAction(_ sender: UIButton) {
        
        moveToStoreDetail((productDetail?.store?._id)!)
    }
    
    
    private func moveToStoreDetail(_ storeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStoreTab") as! VCStoreTab
        print(storeid)
        vc.storeid = storeid
        isResturant = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addToCartProduct(_ dict:[String:Any]){
        var dictoinary = dict
        dictoinary["quantity"] = "\(Int(Productcounter.value))"
        if combination != nil{
           dictoinary["combination"] = combination?._id ?? ""
        }
        startLoading("")
        CartManager().addCartProducts(dictoinary,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            if(self!.productIdCart != ""){
                                self?.delegate?.reloadDataorCart()
                                self?.navigationController?.popViewController(animated: true)
                                //                                let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
                                //                                let vc = storyboard.instantiateViewController(withIdentifier: "VCCart") as! VCCart
                                
                                //self!.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                                //self?.navigationController?.pushViewController(vc, animated: true)
                                
                            }else
                            {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
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
    
    private func setupProductDetsil(_ productdetail:Product){
        productImage.sd_setShowActivityIndicatorView(true)
        productImage.sd_setIndicatorStyle(.gray)
        productImage.sd_setImage(with: URL(string: productdetail.images?.first?.path ?? ""))
        prodcutPrice.text = (currency == "usd") ?
            "$\(productdetail.price?.usd ?? 0)" : "AED\(productdetail.price?.aed ?? 0)"
        
        productname.text = (lang == "en") ? productdetail.productName?.en ?? "" : productdetail.productName?.ar ?? ""
        self.btnstore.setTitle("\((self.lang ?? "" == "en") ? productdetail.store?.storeName?.en ?? "" : productdetail.store?.storeName?.ar ?? "")", for: .normal)
        ratingView.rating = 0.0
        self.favouriteBtn.layer.cornerRadius = 15
        self.favouriteBtn.layer.borderWidth = 0.5
        self.favouriteBtn.layer.borderColor = UIColor.lightGray.cgColor
        if AppSettings.sharedSettings.user.favouriteProducts?.contains(productDetail?._id ?? "") ?? false{
            self.favouritImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.favouritImage.image = #imageLiteral(resourceName: "Favourite")
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 0.6, green: 0.537254902, blue: 0.4901960784, alpha: 1)
        }
        if productdetail.canReviewUsers?.count ?? 0 > 0{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
            self.reviewBtn.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = true
        }else{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.reviewBtn.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = false
        }
        productDescription.text = (lang == "en") ? productdetail.description?.en ?? "" : productdetail.description?.ar ?? ""
    }
    
    
    @IBAction func movetoimagedetailAction(_ sender: UIButton) {
        moveToPhotoDetail()
    }
    //me
    private func moveToPhotoDetail(){
        if(productDetail?.images?.first?.path == ""){
            let alertView = AlertView.prepare(title: "Alert".localized, message: "No Image Found".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
        }else{
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VcZoomImage") as! VcZoomImage
        
            vc.detailImageurl = productDetail?.images?.first?.path ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Product Detail".localized
        if(lang == "ar"){
            showArabicBackButton()
        }else{
            self.addBackButton()
        }
        if AppSettings.sharedSettings.accountType == "seller"{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = false
        }else{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = true
        }
        addButtons()
    }
    
    func addButtons(){
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
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "Search"), for: .normal)
        btn2.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        btn2.addTarget(self, action: #selector(btnSearchClick(_:)), for: .touchUpInside)
        let btnSearch = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setRightBarButtonItems([btnSearch,notificationItem], animated: true)
    }
    
    @objc func notification_message(_ sender: Any){
        moveToNotificationVC()
    }
    
    private func moveToNotificationVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSearchClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProductFilter") as! VCProductFilter
        isFromHome = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addtocartclick(_ sender: Any){
        checKCombination()
        if Productcounter.value == 0.0{
            self.alertMessage(message: "Please Select Your Quantity".localized, completionHandler: nil)
            return
        }
        
        if dictionary != nil{
           addToCartProduct(dictionary!)
        }
    }
    
    @IBAction func makeProductFavourite(_ sender: Any){
        startLoading("")
        ProductManager().makeProductFavourite((productDetail?._id!)!,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let favouriteResponse = response{
                    if favouriteResponse.success!{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        if AppSettings.sharedSettings.user.favouriteProducts?.contains((self?.productDetail?._id!)!) ?? false{
                            self?.favouritImage.image = #imageLiteral(resourceName: "Favourite-red")
                            self?.favouriteBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                            
                        }else{
                            self?.favouritImage.image = #imageLiteral(resourceName: "Favourite")
                            self?.favouriteBtn.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
                        }
                        //self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
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
    
    @IBAction func submitProductReview(_ sender: UIButton) {
        if AppSettings.sharedSettings.accountType == "buyer"{
            moveToPopVC((productDetail?._id!)!)
        }
    }
    
    private func moveToPopVC(_ productid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopUp") as! VCPopUp
        vc.productid = productid
        self.present(vc, animated: true, completion: nil)
    }
}

extension VCProductDetail: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productDetail?.priceables?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resuable :UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProductDetailView", for: indexPath) as! ProductDetailView
            view.lblHeader.text =  (lang == "en") ? productDetail?.priceables?[indexPath.section].feature?.title?.en : productDetail?.priceables?[indexPath.section].feature?.title?.ar
            resuable = view
            return resuable!
        }
        return resuable!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.priceables?[section].characteristics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacteristicsCell", for: indexPath) as! CharacteristicsCell
        cell.setupCell(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row].image ?? "")
        if selectedCell.contains(indexPath){
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.red.cgColor
        }
        else{
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
        selectedCell.append(indexPath)
        cell.characterImage.layer.borderWidth = 2.0
        cell.characterImage.layer.borderColor = UIColor.red.cgColor
        characteristics.append(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")
        features.append(productDetail?.priceables?[indexPath.section].feature?._id ?? "")
        let selectedRows = self.CollectionView.indexPathsForSelectedItems!
        for selectedRow in selectedRows {
            if(selectedRow.section == indexPath.section) && (selectedRow.row != indexPath.row) {
                self.CollectionView.deselectItem(at: selectedRow, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
        if  selectedCell.contains(indexPath){
            selectedCell.remove(at: selectedCell.index(of: indexPath)!)
            characteristics.remove(at: characteristics.index(of: productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")!)
            features.remove(at: features.index(of: productDetail?.priceables?[indexPath.section].feature?._id ?? "")!)
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension VCProductDetail: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail?.reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "reviewcell", for: indexPath) as! ReviewCell
        cell.setupReviewCell(review: (productDetail?.reviews?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

