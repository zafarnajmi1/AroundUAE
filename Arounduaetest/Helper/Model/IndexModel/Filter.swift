//
//  Filter.swift
//  Arounduaetest
//
//  Created by Apple on 16/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

struct FilterData: Decodable {
    var groups: [Groups]?
    let features: [Features]?
}

struct Features: Decodable {
    let title : Title?
    let characteristics : [Characteristics]?
    let isActive : String?
    let _id : String?
}

struct FilterSeachData: Decodable {
    let division : FilterSearchDivision?
}

struct FilterSearchDivision : Decodable {
    let title : Title?
    let sections : [Sections]?
    let manufacturers : [Manufacturers]?
    let image : String?
    let isActive : Bool?
    let _id : String?
}

struct Manufacturers : Decodable {
    let title : Title?
    let image : String?
    let isActive : Bool?
    let _id : String?
}

