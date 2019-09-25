//
//  VCCategory.swift
//  AroundUAE
//
//  Created by Macbook on 19/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCProducList: ButtonBarPagerTabStripViewController {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var groupid = ""
    var divisionid = ""
    var sectionid = ""
    var manufactorid = ""
    var characteristicsid = ""
    var lat = ""
    var long = ""
    var totalPage = 0
    var Location = [String]()
    var min : String?
    var max : String?
    var skip = 0
   var neartofar: String? = ""
    var fromSearch : Bool = false
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.003921568627, blue: 0.2039215686, alpha: 1)
        
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Medium", size: 15)!
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0.6
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1);
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
            //self.moveToViewController(at: 1)
        }

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setNavigationBar()
        if(lang == "en")
        {
            self.addBackButton()
        }else{
            self.showArabicBackButton()
        }
        
        self.addProductFilter()
        self.title = "Products".localized
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCNearByProductList")
        let child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCTopratedProductList")
        let obj_2 = child_2 as! VCTopratedProductList
        obj_2.groupid = groupid
        obj_2.divisionid = divisionid
        obj_2.sectionid = sectionid
        obj_2.characteristicsid = characteristicsid
        obj_2.manufactorid = manufactorid
        //obj_2.neartofar = neartofar
        //obj_2.Location = Location
        obj_2.min = min
        obj_2.max = max
//        obj_2.lat = lat
//        obj_2.long = long
        
        let obj_1 = child_1 as! VCNearByProductList
        obj_1.groupid = groupid
        obj_1.divisionid = divisionid
        obj_1.sectionid = sectionid
        obj_1.characteristicsid = characteristicsid
        obj_1.manufactorid = manufactorid
         obj_1.min = min
        obj_1.max = max
        obj_1.neartofar = neartofar
        obj_1.skip = skip
        //obj_1.myLocation = Location
        return [obj_1, obj_2]
    }
}
