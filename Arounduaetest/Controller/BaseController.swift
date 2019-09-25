
import UIKit
import MBProgressHUD
import DZNEmptyDataSet

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    func showAlert(_ message: String, tryAgainClouser:@escaping (UIAlertAction)->Void){
        
        let alert = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Try Again!".localized, style: UIAlertActionStyle.default, handler: tryAgainClouser)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getControllerRef(controller toPush:String,storyboard:String) -> UIViewController{
        return UIStoryboard(name: storyboard, bundle:nil).instantiateViewController(withIdentifier: toPush)
    }
}

extension UIViewController{
    
    func finishLoading(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func startLoading(_ message:String){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message
        loadingNotification.animationType = .zoom
    }
    
    func alertMessage(message:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title:"", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok".localized, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension BaseController: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Sorry there is no data available".localized
        let attribs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Try Again!".localized
        let attribs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8874343038, green: 0.3020061255, blue: 0.4127213061, alpha: 1)
            ] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}
