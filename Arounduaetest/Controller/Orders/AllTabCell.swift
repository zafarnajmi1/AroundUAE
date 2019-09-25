//
//  AllTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AllTabCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusChk: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblquantity: UILabel!
    
    @IBOutlet weak var lblNameProduct: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
         super.layoutSubviews()
        
        self.ButtonDesign()
    }
    
    func ButtonDesign() {
        self.btnStatus.layer.cornerRadius = 5
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
