//
//  Constants.swift
//  GoRich
//
//  Created by Apple PC on 21/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
//import DeviceKit

let socketURL = "https://www.projects.mytechnology.ae/around-uae/"
let socketPath = "/around-uae/socket.io"

class Constants {
    
    
    
    struct Api {
        struct status {
            static let ok = 200
            static let error = 400
        }
    }
    
    struct NetworkError {
        static let timeOutInterval: TimeInterval = 20
        
        static let error = "Error".localized
        static let internetNotAvailable = "Internet Not Available".localized
        static let pleaseTryAgain = "Please Try Again".localized
        
        static let parsingError = "Couldn't parse data".localized
        static let parsing = 0
        
        static let generic = 4000
        static let genericError = "Please Try Again.".localized
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available".localized
        static let serverError = "Server Not Availabe, Please Try Later.".localized
        
        static let timout = 4001
        static let timoutError = "Network Time Out, Please Try Again.".localized
        
        static let login = 4003
        static let loginMessage = "Unable To Login".localized
        static let loginError = "Please Try Again.".localized
        
        static let internet = 4004
        static let internetError = "Internet Not Available".localized
    }
    
    struct NetworkSuccess {
        static let statusOK = 200
    }
}

enum Storyboards{
    static var Main = "Main"
    static var Home = "Home"
}


