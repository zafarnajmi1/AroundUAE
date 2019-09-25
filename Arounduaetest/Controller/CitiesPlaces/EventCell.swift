//
//  EventCell.swift
//  Arounduaetest
//
//  Created by Apple on 16/04/2019.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var img_eventImage: UIImageView!
    @IBOutlet weak var img_date: UIImageView!
    @IBOutlet weak var img_time: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    
    
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(object : Event){
        lbl_name.text = object.title
        
        let startTime = Date.formatedDateFromString(date: object.startTime!, newFormate: "h:mm a")
        let endTime = Date.formatedDateFromString(date: object.endTime!, newFormate: "h:mm a")
        
        lbl_time.text = ("\(startTime) to \(endTime)")
        
        let startDate = Date.formatedDateFromString(date: object.startTime!, newFormate: "d MMM yyyy")
        let endDate = Date.formatedDateFromString(date: object.endTime!, newFormate: "d MMM yyyy")
        lbl_date.text = ("\(startDate) to \(endDate)")
        
        lbl_description.text = object.description
        img_eventImage.sd_setImage(with: URL(string: object.image ?? ""), placeholderImage: UIImage(named: "Category"))
    }
    
}
