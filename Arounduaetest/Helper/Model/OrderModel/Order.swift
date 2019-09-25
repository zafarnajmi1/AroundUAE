//
//  Order.swift
//  Arounduaetest
//
//  Created by Apple on 17/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

struct OrderData : Decodable {
    let _id : String?
    let orderDetails : [SomeOrderDetails]?
    let status : String?
    let charges : Double?
    let orderNumber : String?
    let payerStatus : String?
    let orderStatus : String?
    let firstName : String?
    let lastName : String?
    let payerId : String?
    let payerEmail : String?
    let paymentId : String?
    let state : String?
    let paymentMethod : String?
    let currency : String?
    let transactionDetails : String?
    let user : String?
    let addresses : [Addresses]?
    let createdAt : String?
    let updatedAt : String?
}

struct SomeOrderDetails : Decodable {
    let _id : String?
    let price : Price?
    let total : OrderTotal?
    let quantity : Int?
    let status : String?
    let order : String?
    let product : OrderProduct?
    let store : String?
    let combinationDetail : [CombinationDetail]?
    let images : [Images]?
    let createdAt : String?
    let updatedAt : String?
    let image : String?
}

struct SellerOrder : Decodable {
    let _id : String?
    let price : Price?
    let total : OrderTotal?
    let quantity : Int?
    let status : String?
    let order : Order?
    let product : Product?
    let store : String?
    let combinationDetail : [CombinationDetail]?
    let images : [Images]?
    let createdAt : String?
    let updatedAt : String?
    let image : String?
}

struct Order : Decodable {
    let _id : String?
    let user : User?
    let addresses : [Addresses]?
}

struct OrderTotal : Decodable {
    let usd : Int?
    let aed : Double?
}

struct OrderProduct : Decodable {
    let _id : String?
    let productName : ProductName?
    let store : OrderStore?
}

struct OrderStore : Decodable {
    let _id : String?
    let storeName : StoreName?
    let shippingDays : Int?
    let image : String?
    let averageRating : Double?
}

struct CombinationDetail : Decodable {
    let _id : String?
    let feature : Feature?
    let characteristic : Characteristic?
}

struct Characteristic : Decodable {
    let _id : String?
    let title : Title?
}

struct CartPaymentModel : Decodable {
    let price : Int?
    let total : Int?
    let quantity : Int?
    let status : String?
    let _id : String?
    let order : String?
    let product : String?
    let store : String?
    let combinationDetail : [CombinationDetail]?
    let images : [Images]?
    let createdAt : String?
    let updatedAt : String?
    let __v : Int?
}

struct UpdateCartQuantity : Decodable {
    let total : OrderTotal?
    let quantity : Int?
    let _id : String?
    let user : String?
    let product : String?
    let store : String?
    //let combinationDetail : [CombinationDetail]?
    let combination : String?
    let price : Price?
    let createdAt : String?
    let updatedAt : String?
}
