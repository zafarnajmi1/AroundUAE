//
//  VcZoomImage.swift
//  Arounduaetest
//
//  Created by Apple on 4/13/19.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage
class VcZoomImage: UIViewController {
     var detailImageurl = ""
    
    @IBOutlet weak var myimage: EEZoomableImageView!
        {
        didSet {
            myimage.minZoomScale = 0.5
            myimage.maxZoomScale = 3.0
            myimage.resetAnimationDuration = 0.7
            //attachedimage.zoomDelegate = self as! ZoomingDelegate
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Picture".localized
        setNavigationBar()
        addBackButton()
        myimage.sd_setShowActivityIndicatorView(true)
        myimage.sd_setIndicatorStyle(.gray)
        myimage.sd_setImage(with: URL(string: detailImageurl), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    

    
}
