

import Foundation
import UIKit
import MBProgressHUD

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension UIViewController {
    open func prepareView() {
        
    }
}

extension UIViewController {
    func displayNavigationBarActivityIndicator() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        navigationItem.titleView = indicator
    }
    
    func dismissNavigationdaBarActivityIndicator() {
        navigationItem.titleView = nil
    }
}

extension UIViewController {
    func performSegue(withIdentifier: String) {
        performSegue(withIdentifier: withIdentifier, sender: self)
    }
}

extension UIViewController {
    
    func setSideMenuGesture(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.sideMenuRespondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.sideMenuRespondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    
    }
    
    @objc func sideMenuRespondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
               // let lang = UserDefaults.standard.string(forKey: "i18n_language")
                
//                if lang == "en" {
//                    navigationController?.popViewController(animated: true)
//                    appDelegate.moveToHome()
//                }else {
//
//                }
                print("test")
                
            case UISwipeGestureRecognizerDirection.left:
                print("test")
                //let lang = UserDefaults.standard.string(forKey: "i18n_language")
                
//                if lang == "en"{
//
//                }else {
//                    navigationController?.popViewController(animated: true)
//                    appDelegate.moveToHome()
//                }
            default:
                break
            }
        }
    }
    
    func setGesture(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
//            case UISwipeGestureRecognizerDirection.right:
//                let lang = UserDefaults.standard.string(forKey: "i18n_language")
//
//                if lang == "en" {
//                    navigationController?.popViewController(animated: true)
//                    dismissVC(completion: nil)
//                }else {
//
//                }
//
//            case UISwipeGestureRecognizerDirection.left:
//                let lang = UserDefaults.standard.string(forKey: "i18n_language")
//
//                if lang == "en"{
//
//                }else {
//                    navigationController?.popViewController(animated: true)
//                    dismissVC(completion: nil)
//                }
            default:
                break
            }
        }
    }
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    func addBackButton(lang : String){
//        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if lang == "ar" {
            showArabicBackButton()
            
        }else if lang == "en" {
            addBackButton()
        }
    }
    func addBackButton(backImage: UIImage = #imageLiteral(resourceName: "back")) {
        hideBackButton()
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClciked))
        navigationItem.leftBarButtonItem  = backButton
    }
    
    func showArabicBackButton() {
        hideBackButton()
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-ar"), style: .plain, target: self, action: #selector(onBackButtonClciked))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func onBackButtonClciked() {
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
    }
    
    func addRightButton(image : String, action: Selector){
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: image), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        btn.addTarget(self, action: action, for: .touchUpInside)
        let btnCard = UIBarButtonItem(customView: btn)
        self.navigationItem.setRightBarButtonItems([btnCard], animated: true)
    }
}

extension UIViewController {
    func hideNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public func transparetNavigationbarWithoutExtensing() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    public func transparetNavigationbar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        edgesForExtendedLayout = .top
    }
    
    
    ///EZSE: Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    public func setNavigationBar(){
        
        let navColor = UIColor(red: 241/255, green: 242/255, blue: 243/255, alpha: 1.0)
        let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor(red: 223/255, green: 48/255, blue: 81/255, alpha: 1.0)
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Raleway-Medium", size: 20)! , NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController!.navigationBar.barStyle = .default
    }
}
extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
}
    
}



