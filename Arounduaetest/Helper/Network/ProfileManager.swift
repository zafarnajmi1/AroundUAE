//
//  ProfileManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProfileManager{
    
    //MARK: - GetUserProfile
    func getUserProfile(successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetUserProfile,
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
    
    //MARK: - ChangePassword
    func changePassword(_ params:changePasswordParams,successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ChangePassword(params),
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
    
    //MARK: - UpdateProfile
    func updateProfile(_ params:updateProfileParams,successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UpdateProfile(params),
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
            print("Add Licence Error :\(error)")
            failureCallback(error)
        })
    }
    
    
    
    
    //MARK: - AddLicence
    func Addlicence( tradeLicense:UIImage,successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
            print(tradeLicense)
        NetworkManager.request(target: .UpdateTradeLicence(userImage: tradeLicense),
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
    
    
    
    
    //MARK: - UploadImage
    func uploadImage(_ image:UIImage,successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void, progressCallBack: @escaping (Double) -> Void){
        NetworkManager.request(target: .UploadImage(userImage: image),
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
        }){(progress) in
            progressCallBack(progress)
        }
    }
    
    //MARK: - RemoveImage
    func removeImage(successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .RemoveImage,
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
    
    //MARK: - AboutPage
    func aboutPage(_ params:AboutPageParams,successCallback : @escaping (Response<ManageAboutpageData>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .AboutPage(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<ManageAboutpageData>.self, from: response){
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
    
    //MARK: - UserStores
    func UserStores(_ pageNo:String,successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UserStores(pageNo: pageNo),
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
}
