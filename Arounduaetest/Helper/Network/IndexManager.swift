//
//  IndexManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class IndexManager{
    
    //MARK: - GetSiteSettings
    func getSiteSettings(successCallback : @escaping (Response<Index>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetSiteSettings,
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Index>.self, from: response){
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
    
    //MARK: - GetSliders
    func getSliders(successCallback : @escaping (Response<Slider>?) -> Void,
     failureCallback : @escaping (NetworkError) -> Void){
     NetworkManager.request(target: .GetSliders,
     success:
     {(response) in
        if let parsedResponse = ServerAPI.parseServerResponse(Response<Slider>.self, from: response){
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
    
    //MARK: - ContactUs
    func contactUs(_ params: ContactUSParams,successCallback : @escaping (Response<Product>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ContactUs(params),
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
    
    //MARK: - FilterSeachData
    func getSearchFilterData(_ params: SearchFilterParams,successCallback : @escaping (Response<FilterSeachData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SearchFilter(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<FilterSeachData>.self, from: response){
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
