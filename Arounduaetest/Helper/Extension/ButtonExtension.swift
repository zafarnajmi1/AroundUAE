//
//  ButtonExtension.swift
//  Arounduaetest
//
//  Created by Apple on 01/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

extension UIImageView{
    func makeRound(){
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}

extension UIButton{
    func makeRound(){
        layer.cornerRadius = frame.size.width / 2
        //layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
    func somemakeRound(){
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}
