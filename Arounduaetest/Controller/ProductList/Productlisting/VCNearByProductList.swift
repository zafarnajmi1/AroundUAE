
import UIKit
import XLPagerTabStrip

var searchKeyword = ""
class VCNearByProductList: BaseController,IndicatorInfoProvider,CellNearProtocol{
    
    func favouriteTapped(cell: CellNearBy) {
        
    }
     var myLocation = [String]()
    var min : String? = ""
    var max : String? = ""
    var skip = 0
    var totalPage = 0
     var isMoreRequestSent = false
    var  endLoadingMoreResults : Bool = false
    var productarray = [Products]()
    var groupid = ""
    var divisionid = ""
    var sectionid = ""
    var manufactorid = ""
    var characteristicsid = ""
     var fromSearch : Bool = false
    var neartofar: String?
    @IBOutlet var collectionViewProductnearby: UICollectionView!{
        didSet{
            collectionViewProductnearby.delegate = self
            collectionViewProductnearby.dataSource = self
            collectionViewProductnearby.alwaysBounceVertical = true
            collectionViewProductnearby.addSubview(refreshControl)
        }
    }
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    fileprivate func setupDelegates(){
        self.collectionViewProductnearby.emptyDataSetSource = self
        self.collectionViewProductnearby.emptyDataSetDelegate = self
        self.collectionViewProductnearby.reloadData()
    }
    
    @objc func refreshTableView() {
        if isFromHome{
            
            searchProducts(isRefresh: true, searchTxt: "")
        }else{
            searchProducts(isRefresh: true, searchTxt: searchKeyword)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myLocation.removeAll()
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
        if isFromHome{
            searchProducts(isRefresh: false, searchTxt: "")
        }else{
            searchProducts(isRefresh: false, searchTxt: searchKeyword)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SearchCompleted"), object: nil)
    }
    
    private func setDataEmpty(){
        groupid = ""
        divisionid = ""
        sectionid = ""
        manufactorid = ""
        characteristicsid = ""
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        setDataEmpty()
        if let data = notification.object as? [Products]{
           productarray = data
           collectionViewProductnearby.reloadData()
        }
    }
    
    private func searchProducts(isRefresh: Bool,searchTxt:String){
        if isRefresh == false{
            startLoading("")
        }
        myLocation.insert("\(SharedData.sharedUserInfo.long ?? 0)", at: 0)
        myLocation.insert("\(SharedData.sharedUserInfo.lat ?? 0)", at: 1)
      
        //https://www.projects.mytechnology.ae/around-uae/groups/divisions/Electronics/5b8e7b0d66595431ec453d0e/5b8e7c3366595431ec453d12/products
        //it's from here //"","1",0,0,["31.5204","74.3587"],searchTxt,[manufactorid],[groupid],[divisionid],[sectionid],[characteristicsid]
        //"","\(skip)",min,max,Location,searchKeyword,[manufactorid],[groupid],[divisionid],[sectionid],[characteristicsid]
        ProductManager().SearchProduct(("","\(skip)",min ?? "",max ?? "",myLocation,searchTxt,[manufactorid],[groupid],[divisionid],[sectionid],[characteristicsid],self.neartofar ?? "true"),
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
                        self?.productarray = productsResponse.data?.products ?? []
                        
//                        if self?.skip == 0 {
//                            self?.productarray = productsResponse.data?.products ?? []
//                        }
//                        else{
//
//                            for object in (productsResponse.data?.products)!{
//                                self?.productarray.append(object)
//                            }
//
//                        }
//                        //                        self?.pagenumber += 1
//                        self?.skip = (self?.productarray.count)!
//                        //                        self!.endLoadingMoreResults =  true
                        
                    }
                    else{
                        if(self?.lang ?? "" == "en")
                        {
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
                        }else
                        {
                           self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: nil)
                        }
                    }
                }else{
                    if(self?.lang ?? "" == "en")
                    {
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                    }else{
                        
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
        return IndicatorInfo(title: "Near By".localized)
    }
    
    func addToCartTapped(cell: CellNearBy){
        let indexpath  = collectionViewProductnearby.indexPath(for: cell)!
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopCart") as! VCPopCart
        vc.product = productarray[indexpath.row]
        self.present(vc, animated: true, completion: nil)
    }
}

extension VCNearByProductList: UICollectionViewDelegate,UICollectionViewDataSource{
   
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
        
//        if indexPath.row == (productarray.count - 1) && !endLoadingMoreResults {
//            if !isMoreRequestSent{
//                isMoreRequestSent = true
//                if isFromHome{
//                    searchProducts(isRefresh: false, searchTxt: "")
//                }else{
//                    searchProducts(isRefresh: false, searchTxt: searchKeyword)
//                }
//            }
//
//        }
        
        //        if self.endLoadingMoreResults == true {
        //
        //            self.skip += 1
        //            searchProducts(isRefresh: true)
        //            }
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        if isFromHome{
            searchProducts(isRefresh: false, searchTxt: "")
        }else{
            searchProducts(isRefresh: false, searchTxt: searchKeyword)
        }
    }
}




