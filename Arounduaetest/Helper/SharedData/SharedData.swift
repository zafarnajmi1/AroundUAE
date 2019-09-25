//
//  SharedData.swift
//  AroundUAE
//
//  Created by Apple on 19/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class SharedData{
    static let sharedUserInfo = SharedData()
    
    
    var filter = FilterObject()
    
    var index = Index.getDefaultObject()
    var setting = Settings.getDefaultObject()
    var pages = [Pages]()
    var sliders = [Sliders]()
    //var userData =  [UserData]()
    var placesDataObj:PlacesData!
    var isSocialLogin : Int!
    var socialId : String!
    var socialName : String!
    var socialEmail : String!
    var userID = ""
    var conversationuserID = ""
    
    var conversationID = ""
    var conversationIDImage = ""
    var username = ""
    var personID = ""
    var conversationArray = [Conversations]()
    var conversationTableId : Int = 0
    var chatTitle = ""
    var lat : Double!
     var long : Double!
}
