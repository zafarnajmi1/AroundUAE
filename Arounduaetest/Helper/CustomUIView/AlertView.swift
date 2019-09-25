//
//  AlertView.swift
//  AroundUAE
//
//  Created by Apple on 19/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AlertView {
    
    class func prepare(title: String, message: String, okAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
            okAction?()
        }
        
        alertController.addAction(OKAction)
        
        return alertController
    }
    
    class func prepare(title: String, action1 title1: String, action2 title2: String?, message: String, actionOne: (() -> ())?, actionTwo: (() -> ())?, cancelAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: title1, style: .default) { action in
            actionOne?()
        }
        
        alertController.addAction(actionOne)
        
        if let _ = title2 {
            let actionTwo = UIAlertAction(title: title2, style: .cancel) { action in
                actionTwo?()
            }
            
            alertController.addAction(actionTwo)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action in
            cancelAction?()
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
