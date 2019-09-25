//
//  CartManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class CartManager{

    //MARK: - GetCartProducts
    func getCartProducts(successCallback : @escaping (Json4Swift_Base?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCartProducts,
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = Json4Swift_Base(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
            {(error) in
                failureCallback(error)
            })
        }
    
    //MARK: - Add Products In Cart
    func addCartProducts(_ params:[String:Any] ,successCallback : @escaping (Response<CombinatonData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .AddProdcutsCart(dict: params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<CombinatonData>.self, from: response){
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
    
    //MARK: - Delete Products In Cart
    func deleteCartProducts(_ params:DeleteProductCartParams ,successCallback : @escaping (DeletModelMain?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .DeleteProductCart(params),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = DeletModelMain(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - Payment In Cart
    func Payment(_ payerid:String?,_ paymentMethod : String,  _ billingAddressid:String,_ shippingAddressid:String ,successCallback : @escaping (Response<[CartPaymentModel]>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .Payment(payerId: payerid, paymentMethod: paymentMethod,billingAddressId: billingAddressid,shippingAddressId: shippingAddressid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<[CartPaymentModel]>.self, from: response){
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
    
    //MARK: - Update Cart Quantity
    func UpdateCartQuantity(_ params:CartQuantityUpdateParams ,successCallback : @escaping (Response<UpdateCartQuantity>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .CartQuantityUpdate(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<UpdateCartQuantity>.self, from: response){
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
    
    //MARK: - UpdateBillingShipping
    func UpdateBillingShipping(_ params:BillingShippingAddressParams ,successCallback : @escaping (Response<User>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UpdateBillingShipping(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<User>.self, from: response){
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
