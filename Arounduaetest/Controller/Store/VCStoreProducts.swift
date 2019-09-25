//
//  VCStoreProducts.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage
import DropDown
class VCStoreProducts: BaseController,IndicatorInfoProvider,storeCellDelegate{
    func favouriteTapped(cell: CellStore) {
        
    }
    @IBOutlet weak var btncategory: UIButton!
    
    @IBOutlet weak var btnsubcategory: UIButton!
    var categoryDropdown = DropDown()
    var SubcategoryDropdown = DropDown()
    var topRated: String  = ""
    var categoryIndx = 0
    var subcategoryIndx = 0
    
    var cats = [String]()
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var lblToprated: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    
    @IBOutlet var collectionViewManageProducts: UICollectionView!
    var productsArray = [StoreProduct]()//[Products]()
    var categoriesArray = [ProductCategory]()
    var subCategoriesArray = [ProductCategory]()
    var storeidProducts = ""
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.btnsubcategory.isEnabled = false
        self.btnsubcategory.layer.borderWidth = 1.0
        self.btnsubcategory.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.btncategory.layer.borderWidth = 1.0
        self.btncategory.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        collectionViewManageProducts.adjustDesign(width: ((view.frame.size.width+25)/2.3))
        collectionViewManageProducts.reloadData()
        fetchCategoreis()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("RemoveSelfie"), object: nil)
        
        print(storeidProducts)
        fetchProductInfo(storeidProducts, isRefresh: false)
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewManageProducts.emptyDataSetSource = self
        self.collectionViewManageProducts.emptyDataSetDelegate = self
        self.collectionViewManageProducts.reloadData()
    }
    
    private func fetchCategoreis(){
//        if isRefresh == false{
            startLoading("")
//        }
        
        StoreManager().getCategories(storeidProducts, successCallback: {[weak self] (response)in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let categoriesResponse = response{
                    if categoriesResponse.success!{
                        self?.categoriesArray = categoriesResponse.data!
                        
//                        self?.fetchSubCategoreis(categoryID: (self?.categoriesArray[0]._id ?? ""))

                    }else{
                        print(categoriesResponse)
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
//                self?.setupDelegates()
            }
            
            }, failureCallback: {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
//                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
        } )

    
    }
    private func fetchSubCategoreis(categoryID : String){
        //        if isRefresh == false{
        startLoading("")
        //        }
        
        StoreManager().getSubcategories(storeidProducts,categoryID, successCallback: {[weak self] (response)in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let categoriesResponse = response{
                    if categoriesResponse.success!{
                        self?.subCategoriesArray = categoriesResponse.data!
                        
                        print("SubCategories Count :\(self?.subCategoriesArray.count)")
                        
                    }else{
                        print(categoriesResponse)
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
                //                self?.setupDelegates()
            }
            
            }, failureCallback: {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    //                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
        } )
        
        
    }
    
    private func fetchProductInfo(_ storeId: String, isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        print(cats.count)
        print(topRated)
        self.productsArray.removeAll()
//        print(categoryIndx)
//        var cats : [String]? = nil
//
//        if categoryIndx > -1 {
//            cats = []
//            /*var categoriesArray = [ProductCategory]()
//             var subCategoriesArray = [ProductCategory]()*/
//
//            cats?.append(categoriesArray[categoryIndx]._id!)
//            if subcategoryIndx > -1 {
//
//                /*var categoriesArray = [ProductCategory]()
//                 var subCategoriesArray = [ProductCategory]()*/
//
//                cats?.append(subCategoriesArray[subcategoryIndx]._id!)
//
//
//            }
//
//        }
        
        
        
        StoreManager().getStoreProduct((storeId,topRated,cats.count == 0 ? nil : cats), successCallback: {[weak self] (response)in
            DispatchQueue.main.async {
                                self?.finishLoading()
                                if let productResponse = response{
                                    if productResponse.success!{
                                        self?.productsArray = productResponse.data!
                                        
                                    }else{
                                        print(response)
                                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                                    }
                                }else{
                                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                                }
                                self?.setupDelegates()
                            }
            
            }, failureCallback: {[weak self](error) in
                            DispatchQueue.main.async {
                                self?.finishLoading()
                                self?.setupDelegates()
                                self?.alertMessage(message: error.message.localized, completionHandler: nil)
                            }
                        } )
        
        
        
//        StoreManager().getStoreDetail(storeId,successCallback:
//            {[weak self](response) in
//                DispatchQueue.main.async {
//                    self?.finishLoading()
//                    if let productResponse = response{
//                        if productResponse.success!{
//                        self?.productsArray = productResponse.data?.products ?? []
//                        }else{
//                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
//                        }
//                    }else{
//                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
//                    }
//                    self?.setupDelegates()
//                }
//            })
//        {[weak self](error) in
//            DispatchQueue.main.async {
//                self?.finishLoading()
//                self?.setupDelegates()
//                self?.alertMessage(message: error.message.localized, completionHandler: nil)
//            }
//        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        if isResturant{
            return IndicatorInfo.init(title: "Food Items".localized)
        }
        return IndicatorInfo.init(title: "Store Products".localized)
    }
    
    func addToCartTapped(cell: CellStore){
        let indexpath  = collectionViewManageProducts.indexPath(for: cell)!
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopCart") as! VCPopCart
        
        var product = Products()
        product._id = productsArray[indexpath.row]._id
        
        vc.product = product
        self.present(vc, animated: true, completion: nil)
    }
    
    private func addProductToFavourite(product_id:String,cellstore:CellStore){
        startLoading("")
        ProductManager().makeProductFavourite(product_id,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if let favouriteResponse = response{
                    AppSettings.sharedSettings.user = favouriteResponse.data!
                    if AppSettings.sharedSettings.user.favouriteProducts?.contains((product_id)) ?? false{
                        cellstore.favouriteImage.image = #imageLiteral(resourceName: "Favourite-red")
                        cellstore.UIButtonFavourite.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    }else{
                        cellstore.favouriteImage.image = #imageLiteral(resourceName: "Favourite")
                        cellstore.UIButtonFavourite.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.1176470588, blue: 0.0862745098, alpha: 1)
                    }
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
                self?.finishLoading()
            }
        }){[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    //mehere
    @IBAction func TopRatedAction(_ sender: UIButton) {
        
        if(self.checkBox.image == #imageLiteral(resourceName: "Checked-1")){
            self.checkBox.image = #imageLiteral(resourceName: "checkbox")
            self.topRated = "false"
            self.productsArray.removeAll()
            self.cats.removeAll()
            self.fetchProductInfo(self.storeidProducts , isRefresh: false)
        }else{
            self.checkBox.image = #imageLiteral(resourceName: "Checked-1")
            self.topRated = "true"
            self.productsArray.removeAll()
            self.cats.removeAll()
            self.fetchProductInfo(self.storeidProducts , isRefresh: false)
           
        }
        
    }
    
    
    @IBAction func CategoryAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = btncategory // UIView or UIBarButtonItem
        
        var categoryList = self.categoriesArray.map({$0.title?.en ?? "" })
        categoryList.insert("Category".localized, at: 0)
        dropDown.dataSource = categoryList
        dropDown.show()
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.categoryIndx = index - 1
            print(self.categoryIndx)
            if(item == "Category"){
              self.lblcategory.text = "Category".localized
                self.lblSubCategory.text = "SubCategory".localized
             self.btnsubcategory.isEnabled = false
                 self.cats.removeAll()
                self.productsArray.removeAll()
                self.fetchProductInfo(self.storeidProducts , isRefresh: false)
               
            }else{
                self.btnsubcategory.isEnabled =  true
                self.lblcategory.text = item
                self.lblcategory.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                print(self.categoriesArray[self.categoryIndx]._id!)
                //self.cats?.insert(self.categoriesArray[self.categoryIndx]._id!, at: 0)
                self.cats.removeAll()
                self.cats.append(self.categoriesArray[self.categoryIndx]._id!)
                self.productsArray.removeAll()
                self.fetchSubCategoreis(categoryID: (self.categoriesArray[self.categoryIndx]._id ?? ""))
                self.fetchProductInfo(self.storeidProducts , isRefresh: false)
            }
        }
        
        
    }
    @IBAction func SubcategoryAction(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        dropDown.anchorView = btnsubcategory // UIView or UIBarButtonItem
        var SubcategoryList = self.subCategoriesArray.map({$0.title?.en ?? "" })
        SubcategoryList.insert("SubCategory".localized, at: 0)
        dropDown.dataSource = SubcategoryList
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.subcategoryIndx = index - 1
            if(item == "SubCategory"){
                self.lblSubCategory.text = "SubCategory".localized
                
                self.productsArray.removeAll()
               
                self.fetchProductInfo(self.storeidProducts , isRefresh: false)
            }else{
                self.btnsubcategory.isEnabled  = true
                self.lblSubCategory.text = item
                self.lblSubCategory.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.productsArray.removeAll()
                print(self.subCategoriesArray[self.subcategoryIndx]._id!)
                self.cats.append(self.subCategoriesArray[self.subcategoryIndx]._id!)
               // self.cats?.insert(self.subCategoriesArray[self.subcategoryIndx]._id!, at: 1)
                self.fetchProductInfo(self.storeidProducts , isRefresh: false)
            
            }
        }
        
    }
    
}

extension VCStoreProducts: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CellStore", for: indexPath) as! CellStore
        if AppSettings.sharedSettings.accountType != "seller"{
           cell.delegate = self
        }
        let product = productsArray[indexPath.row]
        cell.setupProductCell(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppSettings.sharedSettings.accountType != "seller"{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProductDetail") as! VCProductDetail
            var product = Products()
            product._id = productsArray[indexPath.row]._id
            
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchProductInfo(storeidProducts, isRefresh: false)
    }
}
