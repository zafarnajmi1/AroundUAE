//
//  StoreManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Moya

class StoreManager{
    //MARK: - CATEGORIES
    func getCategories(_ storeID:String, successCallback : @escaping (Response<[ProductCategory]>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCategories(storeID, nil),
                               success:
            {(response) in
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                print("Get Categories Response :\(json)")
                if let parsedResponse = ServerAPI.parseServerResponse(Response<[ProductCategory]>.self, from: response){
                    successCallback(parsedResponse)
                }else{
                    failureCallback(NetworkManager.networkError)
                }
        },
                               failure:
            {(error) in
                failureCallback(error)
        })
    }
    //MARK: - SubCategories
    func getSubcategories(_ storeID:String,_ categoryID : String, successCallback : @escaping (Response<[ProductCategory]>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCategories(storeID, categoryID),
                               success:
            {(response) in
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                print("Get Sub Categories Response :\(json)")
                if let parsedResponse = ServerAPI.parseServerResponse(Response<[ProductCategory]>.self, from: response){
                    successCallback(parsedResponse)
                }else{
                    failureCallback(NetworkManager.networkError)
                }
        },
                               failure:
            {(error) in
                failureCallback(error)
        })
    }
    //MARK: - STORES
    func getStores(_ pageNo:String, successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetStores(pageNo: pageNo),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Store>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - STORE DETAIL
    func getStoreDetail(_ storeID:String, successCallback : @escaping (Response<StoreDetail>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreDetail(storeId: storeID),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<StoreDetail>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    
    
    //MARK: - GET STORE PRODUCT
//    func getStoreProduct(_ storeID:String, pagno: Int , successCallback : @escaping (Response<StoreDetail>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
//        NetworkManager.request(target: .StoreDetail(storeId: storeID),
//                               success:
//            {(response) in
//                if let parsedResponse = ServerAPI.parseServerResponse(Response<StoreDetail>.self, from: response){
//                    successCallback(parsedResponse)
//                }else{
//                    failureCallback(NetworkManager.networkError)
//                }
//        },
//                               failure:
//            {(error) in
//                failureCallback(error)
//        })
//    }
    //StoreItemsResponse
//    //MARK: - StoreProducts
    func getStoreProduct(_ params:StoreProductUpdated,successCallback : @escaping (Response<[StoreProduct]>?) -> Void,
                       failureCallback : @escaping (NetworkError) -> Void){
//           print(storeid)
//           print(pageno)
        NetworkManager.request(target: .storProductupdated(params),
                               success:
            {(response) in
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                print("Get Events Response :\(json)")
                if let parsedResponse = ServerAPI.parseServerResponse(Response<[StoreProduct]>.self, from: response){
                    print(parsedResponse)
                    successCallback(parsedResponse)
                }else{
                    failureCallback(NetworkManager.networkError)
                }
        },
                               failure:
            {(error) in
                failureCallback(error)
        })
    }
    
    
//    //MARK: - Delete Products In Cart
//    func deleteCartProducts(_ params:DeleteProductCartParams ,successCallback : @escaping (DeletModelMain?) -> Void,
//                            failureCallback : @escaping (NetworkError) -> Void){
//        NetworkManager.request(target: .DeleteProductCart(params),
//                               success:
//            {(response) in
//                let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
//                let json4Swift_Base = DeletModelMain(dictionary: someDictionaryFromJSON as NSDictionary)
//                successCallback(json4Swift_Base)
//        },
//                               failure:
//            {(error) in
//                failureCallback(error)
//        })
//    }
    
    
    
    //MARK: - RESTURANTS
    func getResturants(_ pageNo:String, successCallback : @escaping (Response<Resturants>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetResturants(pageNo: pageNo),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Resturants>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - Store Review
    func storeReview(_ params:StoreReviewParams, successCallback : @escaping (Response<Resturants>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreReview(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Resturants>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
}
