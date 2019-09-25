//
//  ProductManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProductManager{
    
    //MARK: - ProductDetail
    func productDetail(_ productid:String,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ProductDetail(productId: productid),
        success:
        {(response) in
            
            let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
            //                let json = JSONSerialization.JSONObjectWithData(response, options: )
            print("Get Events Response :\(json)")
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
                successCallback(parsedResponse)
                print(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }

    //MARK: - StoreProducts
    func storeProducts(_ pageno:String, storeid:String,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreProducts(pageNo:pageno,storeId:storeid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
   
    //MARK: - EditProduct
    func editProduct(_ productid:String,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .EditProduct(productId: productid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
    
    //MARK: - DeleteProduct
    func deleteProduct(_ productid:String,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .DeleteProduct(productId: productid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
    
    //MARK: - DeleteProductImage
    func deleteProductImage(_ params: DeleteProductImageParams,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .DeleteProductImage(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
    
    //MARK: - SetDefaultProductImage
    func setDefaultProductImage(_ params: DeleteProductImageParams,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SetDefaultProductImage(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
    
    //MARK: - GetStoreSGDS
    func getStoreSGDS(successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetStoreSGDS,
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Product>.self, from: response){
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
    
    //MARK: - GetFeaturesCharacters
    func getFeaturesCharacters(_ params: FeaturesAndCharacteristicsParams,successCallback : @escaping (Response<featureandcharacterticsData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetFeaturesCharacters(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<featureandcharacterticsData>.self, from: response){
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
    
    //MARK: - MakeProductFavourite
    func makeProductFavourite(_ productid:String,successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .MakeProductFavourite(productId: productid),
        success:
        {(response) in
            
            let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
            //                let json = JSONSerialization.JSONObjectWithData(response, options: )
            print("Get Events Response :\(json)")
            
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
    
    //MARK: - GetFavouriteProducts
    func getFavouriteProducts(_ pageno:String,successCallback : @escaping (Response<FavouriteProductData>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetFavouriteProducts(pageNo: pageno),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<FavouriteProductData>.self, from: response){
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
    
    //MARK: - SubmitPlaceReview
    func submitProductReview(_ params:ProductReviewParams ,successCallback : @escaping (Response<placeReview>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ProductReview(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<placeReview>.self, from: response){
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
    
    //MARK: - SearchProduct 1
    func SearchProduct(_ params:SearchParams,successCallback : @escaping(Response<SearchProductData>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        print(" Pramameters from search Product  :\(params)")
        NetworkManager.request(target: .SearchProduct(params),
        success:
        {(response) in
            let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
            //                let json = JSONSerialization.JSONObjectWithData(response, options: )
            print("Get Events Response :\(json)")
            if let parsedResponse = ServerAPI.parseServerResponse(Response<SearchProductData>.self, from: response){
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
