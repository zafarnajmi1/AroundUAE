
import UIKit

class VCFilteredProductList: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
   
    @IBOutlet var collectionViewProductnearby: UICollectionView!{
        didSet{
            collectionViewProductnearby.delegate = self
            collectionViewProductnearby.dataSource = self
        }
    }
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var productarray:[Products]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellNearBy", for: indexPath) as! CellNearBy
        if(lang == "en"){
        cell.lblproductnamenearby.text = productarray[indexPath.row].productName?.en
       }else {
         cell.lblproductnamenearby.text = productarray[indexPath.row].productName?.ar
        }
        return cell
    }
}
