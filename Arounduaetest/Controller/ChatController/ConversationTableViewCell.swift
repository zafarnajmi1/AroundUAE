//
//  ConversationTableViewCell.swift
//  HelloStream
//
//  Created by iOSDev on 6/21/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet var imageConversation: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lbltext: UILabel!
    @IBOutlet var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
