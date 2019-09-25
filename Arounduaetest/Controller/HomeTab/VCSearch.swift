////
////  VCSearch.swift
////  AroundUAE
////
////  Created by Zafar Najmi on 05/10/2018.
////  Copyright © 2018 Zafar Najmi. All rights reserved.
////
//
//import UIKit
//import SwiftRangeSlider
//import DropDown
//
//class VCSearch: UIViewController {
//
//    @IBOutlet weak var ViewRanger: RangeSlider!
//    @IBOutlet weak var lblPriceranger: UILabel!
//    @IBOutlet weak var filterTableView: UITableView!
//    @IBOutlet weak var filterTableConstraint: NSLayoutConstraint!
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    var featuresArray = [FeatureCharacterData]()
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        getFeatureWithCharacteristics()
//    }
//    
//    private func setViewHeight(){
//        filterTableConstraint.constant = filterTableView.contentSize.height + 50
//        self.filterTableView.setNeedsDisplay()
//    }
//    
//    private func getFeatureWithCharacteristics(){
//        startLoading("")
//        ProductManager().getFeaturesCharacters(
//            successCallback:
//            {[weak self](response) in
//                DispatchQueue.main.async {
//                    self?.finishLoading()
//                    if let productsResponse = response{
//                        if productsResponse.success!{
//                            self?.featuresArray = productsResponse.data ?? []
//                            self?.filterTableView.reloadData()
//                            self?.setViewHeight()
//                        }
//                        else{
//                            if(lang == "en"){
//                                self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
//                            }else{
//                                self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: nil)
//                            }
//                        }
//                    }else{
//                        if(lang == "en"){
//                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
//                        }else{
//                            self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
//                        }
//                    }
//                }
//            })
//        {[weak self](error) in
//            DispatchQueue.main.async {
//                self?.finishLoading()
//                self?.alertMessage(message: error.message.localized, completionHandler: nil)
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.viewWillLayoutSubviews()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.title = "Product Filter".localized
//        self.addBackButton()
//        self.setNavigationBar()
//    }
//}
//
//extension VCSearch: UITableViewDelegate,UITableViewDataSource,featureCellProtocol{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return featuresArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! featureCell
//        if(lang == "en")
//        {
//        cell.featureName.text = featuresArray[indexPath.row].title?.en ?? ""
//        }else
//        {
//             cell.featureName.text = featuresArray[indexPath.row].title?.ar ?? ""
//        }
//        cell.delegate = self
//        cell.menudropDown.anchorView = cell.backgroundBtn
//        cell.menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        cell.menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        if(lang == "en")
//        {
//        cell.menudropDown.dataSource = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""}))!
//        }else{
//             cell.menudropDown.dataSource = (featuresArray[indexPath.row].characteristics?.map({$0.title?.ar ?? ""}))!
//            
//        }
//        cell.menudropDown.selectionAction = {(index: Int, item: String) in
//            cell.featureName.text = item
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//    
//    func didtap(cell:featureCell){
//        cell.menudropDown.show()
//    }
//}
//
