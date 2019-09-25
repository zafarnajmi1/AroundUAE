//
//  CellT.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class CellT: UITableViewCell {
    @IBOutlet var TCollectionView: UICollectionView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
(dataSourceDelegate: D, forRow row: Int) {
        
        TCollectionView.delegate = dataSourceDelegate
        TCollectionView.dataSource = dataSourceDelegate
        TCollectionView.tag = row
        TCollectionView.reloadData()
    }

}
