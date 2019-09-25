
import UIKit
import SDWebImage

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    var detailImageurl = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavigationBar()
        addBackButton()
        self.title = "Picture".localized
        scrolView.delegate = self
        scrolView.minimumZoomScale = 1.0
        scrolView.maximumZoomScale = 10.0
        imgPhoto.sd_setShowActivityIndicatorView(true)
        imgPhoto.sd_setIndicatorStyle(.gray)
        imgPhoto.sd_setImage(with: URL(string: detailImageurl), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgPhoto
    }
}

