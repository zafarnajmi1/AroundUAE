//
//  AuthManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Moya

class GDSManager{

    //MARK: - GET GROUPS
    func getGroups(successCallback : @escaping (Response<GroupData>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetGroups,
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<GroupData>.self, from: response){
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
    
    //MARK: - GET GROUP WITH DIVISION
    func getGroupsWithDivisons(successCallback : @escaping (Response<[GroupDivisonData]>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetGroupWithDivision,
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<[GroupDivisonData]>.self, from: response){
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
    
    //MARK: - GET DIVISONS OF GROUP
    func gethDivisonsOfGoup(_ groupid:String ,successCallback : @escaping (Response<[GroupDivisonData]>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetGroupsDivision(groupId: groupid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<[GroupDivisonData]>.self, from: response){
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
