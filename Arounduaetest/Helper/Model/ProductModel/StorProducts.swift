//
//  StorProducts.swift
//  Arounduaetest
//
//  Created by Apple on 4/16/19.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import Foundation


//struct StoreItemsResponse : Decodable {
//    let success : Bool?
//    let message : Message?
//    let products : [StoreProduct]?
//    let errors : Errors?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case success = "success"
//        case message = "message"
//        case products = "data"
//        case errors = "errors"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        message = try values.decodeIfPresent(Message.self, forKey: .message)
//        products = try values.decodeIfPresent([StoreProduct].self, forKey: .products)
//        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
//    }
//    
//}
//
//
//struct StoreProduct: Decodable {
//    let _id : String?
//    let productName : ProductName?
//    let price : Price?
//    let averageRating : Int?
//    let store : Stores?
//    let images : [Images]?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case _id = "_id"
//        case productName = "productName"
//        case price = "price"
//        case averageRating = "averageRating"
//        case store = "store"
//        case images = "images"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        productName = try values.decodeIfPresent(ProductName.self, forKey: .productName)
//        price = try values.decodeIfPresent(Price.self, forKey: .price)
//        averageRating = try values.decodeIfPresent(Int.self, forKey: .averageRating)
//        store = try values.decodeIfPresent(Stores.self, forKey: .store)
//        images = try values.decodeIfPresent([Images].self, forKey: .images)
//    }
//    
//}
