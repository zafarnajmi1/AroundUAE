//
//  CellStores.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage

class CellStores: UICollectionViewCell {
    
    @IBOutlet var imgStores: UIImageView!
    @IBOutlet var lblStore: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func awakeFromNib() {
        imgStores.image = nil
        lblStore.text = nil
    }
    
    func setupStoreCell(_ store: Stores){
        lblStore.text = (lang == "en") ? store.storeName?.en ?? "" : store.storeName?.ar ?? ""
        imgStores.sd_setShowActivityIndicatorView(true)
        imgStores.sd_setIndicatorStyle(.gray)
        imgStores.sd_setImage(with: URL(string: store.image ?? ""))
    }
    
    func setupSubDivisonCell(_ divisionData: GroupDivisonData){
        lblStore.text = (lang == "en") ? divisionData.title?.en ?? "" : divisionData.title?.ar ?? ""
        imgStores.sd_setShowActivityIndicatorView(true)
        imgStores.sd_setIndicatorStyle(.gray)
        imgStores.sd_setImage(with: URL(string: divisionData.image ?? ""))
    }
}
