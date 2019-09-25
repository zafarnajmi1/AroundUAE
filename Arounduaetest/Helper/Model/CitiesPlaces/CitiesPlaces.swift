//
//  CitiesPlaces.swift
//  AroundUAE
//
//  Created by Apple on 28/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct Cities: Decodable {
    let _id : String?
    let title : Title?
    let image : String?
}

struct CitiesData : Decodable {
    let cities : [Cities]?
    let pagination : Pagination?
}

struct PlacesData : Decodable {
    let places : [Places]?
    let pagination : Pagination?
}

//struct Places : Decodable {
//    let _id : String?
//    let title : Title?
//    let averageRating : Double?
//    let images : [Images]?
//}

struct Places : Decodable {
    let _id : String?
    let about : About?
    let title : Title?
    let description : Description?
    let reviews : [Places_Reviews]?
    let averageRating : Double?
    let address : String?
    let location : [Double]?
    let images : [Images]?
    let selfies: [Selfies]?
}

struct Places_Reviews : Decodable {
    let _id : String?
    let rating : Int?
    let comment : String?
    let place : String?
    let user : User?
    let createdAt : String?
    let updatedAt : String?
}

struct placeReview : Decodable {
    let rating : Int?
    let comment : String?
    let _id : String?
    let place : String?
    let user : String?
    let createdAt : String?
    let updatedAt : String?
}

struct EventsData : Decodable {
    let events : [Event]?
    let pagination : Pagination?
}
struct Event : Decodable  {
    var _id : String?
    var title : String?
    var description : String?
    var image : String?
    var eventDate : String?
    var startTime : String?
    var endTime : String?
    
    var eventEndDate: String?
    var fullName :  String?
    var email : String?
    var phone :  String?
}
struct EventDetail : Decodable   {
    let _id : String?
    let title : String?
    let description : String?
    let image : String?
    let eventDate : String?
    let startTime : String?
    let endTime : String?
    let fullName : String?
    let email : String?
    let phone : String?
    let eventendDate : String?
    
    
    let city : String?
    let createdAt : String?
    let updatedAt : String?
    let isActive : Bool?
    
}


