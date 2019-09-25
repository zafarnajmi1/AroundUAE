//
//  VCPopCart.swift
//  Arounduaetest
//
//  Created by Apple on 16/11/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCPopCart: UIViewController {

    var product:Products!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    let currency = UserDefaults.standard.string(forKey: "currency")
    var Count = ""
    var productDetail:Product?
    var selectedCell = [IndexPath]()
    var features = [String]()
    var characteristics = [String]()
    var combination:Combinations?
    var dictionary:[String:Any]?
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var Productcounter: GMStepperCart!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var CollectionView: UICollectionView!{
        didSet{
            CollectionView.delegate = self
            CollectionView.dataSource = self
            CollectionView.allowsSelection = true
            CollectionView.allowsMultipleSelection = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
    }
    
    override func viewDidLayoutSubviews(){
        super.updateViewConstraints()
        collectionViewHeight.constant = CollectionView.contentSize.height
        scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollview.contentSize.height)
        if scrollview.contentSize.height < 600{
            scrollViewHeight.constant = scrollview.contentSize.height
        }
    }
    
    private func getProductDetail(){
        startLoading("")
        ProductManager().productDetail(product._id!,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.productDetail = storeResponse.data!
                        self?.CollectionView.reloadData()
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "" , completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func checKCombination(){
        
        var dic = [String:Any]()
        dic["product"] = product._id!
        dic["quantity"] = "\(Int(Productcounter.value))"
        
        if productDetail?.hasCombinations ?? false{
            
            if features.count == 0 || characteristics.count == 0{
                self.alertMessage(message: "Please Select Some Combination or Feature...".localized, completionHandler: nil)
                return
            }
            
            guard let comb = combination,
                let avaliablecount = comb.avalaible,avaliablecount > Int(Productcounter.value) else{
                    self.alertMessage(message: "Product is not avaliable in your desired quantity".localized, completionHandler: nil)
                    return
            }
            
            if let combinations = productDetail?.combinations{
                for obj in combinations{
                    if obj.features! != features || obj.characteristics! != characteristics {
                        self.alertMessage(message: "Could not find combination!!", completionHandler: nil)
                    }else if obj.features! == features && obj.characteristics! == characteristics{
                        combination = obj
                        dictionary = dic
                        break
                    }
                }
            }
        }else{
            dictionary = dic
        }
    }
    
    @IBAction func addtocartclick(_ sender: Any){
        checKCombination()
        if Productcounter.value == 0.0{
            self.alertMessage(message: "Please Select Your Quantity".localized, completionHandler: nil)
            return
        }
        
        if dictionary != nil{
            addToCartProduct(dictionary!)
        }
    }
    
    private func addToCartProduct(_ dict:[String:Any]){
        var dictoinary = dict
        dictoinary["quantity"] = "\(Int(Productcounter.value))"
        if combination != nil{
            dictoinary["combination"] = combination?._id ?? ""
        }
        startLoading("")
        CartManager().addCartProducts(dictoinary,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

extension VCPopCart: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productDetail?.priceables?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resuable :UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProductDetailView", for: indexPath) as! ProductDetailView
            view.lblHeader.text =  (lang == "en") ? productDetail?.priceables?[indexPath.section].feature?.title?.en : productDetail?.priceables?[indexPath.section].feature?.title?.ar
            resuable = view
            return resuable!
        }
        return resuable!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.priceables?[section].characteristics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacteristicsCell", for: indexPath) as! CharacteristicsCell
        cell.setupCell(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row].image ?? "")
        if selectedCell.contains(indexPath){
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.red.cgColor
        }
        else{
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
        selectedCell.append(indexPath)
        cell.characterImage.layer.borderWidth = 2.0
        cell.characterImage.layer.borderColor = UIColor.red.cgColor
        characteristics.append(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")
        features.append(productDetail?.priceables?[indexPath.section].feature?._id ?? "")
        let selectedRows = self.CollectionView.indexPathsForSelectedItems!
        for selectedRow in selectedRows {
            if(selectedRow.section == indexPath.section) && (selectedRow.row != indexPath.row) {
                self.CollectionView.deselectItem(at: selectedRow, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
        if  selectedCell.contains(indexPath){
            selectedCell.remove(at: selectedCell.index(of: indexPath)!)
            characteristics.remove(at: characteristics.index(of: productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")!)
            features.remove(at: features.index(of: productDetail?.priceables?[indexPath.section].feature?._id ?? "")!)
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
