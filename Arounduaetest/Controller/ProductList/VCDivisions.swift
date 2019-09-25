//
//  VCCategory.swift
//  AroundUAE
//
//  Created by Macbook on 19/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCDivisions: ButtonBarPagerTabStripViewController {
    
    var groupid:String?
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .red
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Medium", size: 13)!
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0.3
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = UIColor.lightGray;       settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        }
        
        super.viewDidLoad()
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Filter"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        btn1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let btnCard = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([btnCard], animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.addBackButton()
        self.title = "Products"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCNearBy")
        let child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCtest")
        return [child_1, child_2]
    }
    
    @objc func buttonTapped(){
        performSegue(withIdentifier: "ProductsToFilter", sender: self)
    }
}
