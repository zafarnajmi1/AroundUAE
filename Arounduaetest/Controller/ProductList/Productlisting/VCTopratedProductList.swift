
import UIKit
import XLPagerTabStrip

class VCTopratedProductList: BaseController, IndicatorInfoProvider,CellNearProtocol{
    
    var productarray = [Products]()
    var groupid = ""
    var divisionid = ""
    var sectionid = ""
    var manufactorid = ""
    var characteristicsid = ""
//    var lat = ""
//    var long = ""
    var Location = [String]()
    var min : String?
    var max : String?
   var  endLoadingMoreResults : Bool = false
    var isMoreRequestSent = false
    var  pagenumber = 1
    var fromSearch : Bool = false
    var neartofar: String? = ""
    var skip = 0
    var totalPage = 0
    @IBOutlet var collectionViewProductnearby: UICollectionView!{
        didSet{
            collectionViewProductnearby.delegate = self
            collectionViewProductnearby.dataSource = self
            collectionViewProductnearby.alwaysBounceVertical = true
            collectionViewProductnearby.addSubview(refreshControl)
        }
    }
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    fileprivate func setupDelegates(){
        self.collectionViewProductnearby.emptyDataSetSource = self
        self.collectionViewProductnearby.emptyDataSetDelegate = self
        self.collectionViewProductnearby.reloadData()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    
    @objc func refreshTableView() {
        searchProducts(isRefresh: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addProductFilter()
        self.title = "Products".localized
        
        if(lang == "ar")
        {
            self.showArabicBackButton()
            
            
        }else if(lang == "en")
        {
            self.addBackButton()
           
            
        }
        
        
//        self.endLoadingMoreResults =  false
//        print(lat)
        collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
        if !isFromHome{
            groupid = ""
        }
        
        
        searchProducts(isRefresh: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SearchCompleted"), object: nil)
    }
    
    
    private func addProductFilter(){
        let btn2 = UIButton(type: .custom)
        btn2.setImage(#imageLiteral(resourceName: "Filter"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn2.addTarget(self, action: #selector(btnSearchClick), for: .touchUpInside)
        let btnfilter = UIBarButtonItem(customView: btn2)
        self.navigationItem.setRightBarButtonItems([btnfilter], animated: true)
    }
    
    @objc func btnSearchClick() {
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProductFilter") as! VCProductFilter
        isFromHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    private func setDataEmpty(){
        groupid = ""
        divisionid = ""
        sectionid = ""
        manufactorid = ""
        characteristicsid = ""
//        lat = ""
//        long = ""
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        setDataEmpty()
        if let data = notification.object as? [Products]{
            productarray = data
            collectionViewProductnearby.reloadData()
        }
    }
    
    private func searchProducts(isRefresh: Bool){
        if isRefresh == false{
            startLoading("")
        }

        
        ProductManager().SearchProduct(("","\(skip)",min ?? "" ,max ?? "",Location,searchKeyword,[manufactorid],[groupid],[divisionid],[sectionid],[characteristicsid],""),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                if let productsResponse = response{
                    if productsResponse.success!{
                        
                        if productsResponse.data?.products?.count == 0 {
                            self!.endLoadingMoreResults =  true
                        }
                        
                        
                        if self?.skip == 0 {
                            self?.productarray = productsResponse.data?.products ?? []
                        }
                        else{
                            
                            for object in (productsResponse.data?.products)!{
                                self?.productarray.append(object)
                            }
                            
                        }
//                        self?.pagenumber += 1
                        self?.skip = (self?.productarray.count)!
//                        self!.endLoadingMoreResults =  true
                        
                        
                        
//                        self?.skip = (productsResponse.data?.products?.count)!
                        
                        
                        self?.collectionViewProductnearby.reloadData()
                    }
                    else{
                        if(self?.lang ?? "" == "en")
                        {
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
                        }
                        else{
                            self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: nil)
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
                self?.setupDelegates()
            }
            self?.isMoreRequestSent = false
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
            self?.isMoreRequestSent = false
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "Top Rated".localized)
    }
    
    func addToCartTapped(cell: CellNearBy){
        let indexpath  = collectionViewProductnearby.indexPath(for: cell)!
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopCart") as! VCPopCart
        vc.product = productarray[indexpath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    func favouriteTapped(cell: CellNearBy){
        let indxpath = collectionViewProductnearby.indexPath(for: cell)
        
        if let path = indxpath, let productid = productarray[path.row]._id{
            addProductToFavourite(product_id: productid,cellnearBy: cell)
        }
    }
    
    private func addProductToFavourite(product_id:String,cellnearBy:CellNearBy){
        print(product_id)
        startLoading("")
        ProductManager().makeProductFavourite(product_id,
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    if let favouriteResponse = response{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        if AppSettings.sharedSettings.user.favouriteProducts?.contains((product_id)) ?? false{
                            cellnearBy.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite-red")
                            cellnearBy.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }else{
                            cellnearBy.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite")
                            cellnearBy.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.1176470588, blue: 0.0862745098, alpha: 1)
                        }
                               //self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
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
}

extension VCTopratedProductList: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellNearBy", for: indexPath) as! CellNearBy
        cell.setupNearbyData(product: productarray[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppSettings.sharedSettings.accountType != "seller"{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProductDetail") as! VCProductDetail
            vc.product = productarray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (productarray.count - 1) && !endLoadingMoreResults {
            if !isMoreRequestSent{
                isMoreRequestSent = true
                searchProducts(isRefresh: true)
            }
            
        }
        
//        if self.endLoadingMoreResults == true {
//
//            self.skip += 1
//            searchProducts(isRefresh: true)
//            }

    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        searchProducts(isRefresh: false)
    }
}
