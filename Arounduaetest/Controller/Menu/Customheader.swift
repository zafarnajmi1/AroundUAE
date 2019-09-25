//
//  Customheader.swift
//  Arounduaetest
//
//  Created by Apple on 22/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

protocol CustomHeaderDelegate: class {
    func didTapButton(in section: Int)
}

class CustomHeader: UITableViewCell {
    weak var delegate: CustomHeaderDelegate?
    
    
    override func awakeFromNib() {
        self.imgUserProfile.layer.cornerRadius = 30
        self.imgUserProfile.clipsToBounds = true
        self.imgUserProfile.layer.borderWidth = 0.5
        self.imgUserProfile.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBOutlet weak var lblUserProfileMail: UILabel!
    @IBOutlet weak var lblUserProfilename: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    var sectionNumber: Int!
    
    @IBAction func didTapButton(_ sender: AnyObject) {
        delegate?.didTapButton(in: sectionNumber)
    }
}
