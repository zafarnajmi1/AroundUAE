//
//  AuthManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Moya

class AuthManager{
    
    //MARK: - LOGIN USER
    func loginUser(_ params:LoginParams, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UserLogin(params),
        success:
        {(response) in
            let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
            //                let json = JSONSerialization.JSONObjectWithData(response, options: )
            print("Login User Response :\(json)")
            if let parsedResponse = ServerAPI.parseServerResponse(Response<User>.self, from: response){
                print(response)
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
    
    //MARK: - REGISTER USER
    func registerUser(_ params:RegisterUserParams, userImage: UIImage, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .RegisterUser(params, userImage: userImage),
        success:
        {(response) in
            let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
            //                let json = JSONSerialization.JSONObjectWithData(response, options: )
            print("Add Events Response :\(json)")
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
    
    //MARK: - FORGOTPASSWORD USER
    func forgotPassword(_ userEmail:String, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ForgotPassword(userEmail: userEmail),
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
    
    //MARK: - CHANGE PASSWORD USER
    func changePassword(_ params:changePasswordParams, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
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
    
    //MARK: - RESET PASSWORD USER
    func resetPassword(_ params:resetPasswordParams, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ResetPassword(params),
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
    
    //MARK: - EMAIL_VERIFICATION USER
    func emailverificationPassword(_ params:EmailverificationParams, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .EmailVerification(params),
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
    
    //MARK: - RESEND_VERIFICATION_CODE USER
    func ResendverificationCode(_ userEmail:String, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ResendVerification(userEmail: userEmail),
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
    
     //MARK: - SOCIAL_LOGIN
    func SocialLogin(_ params:SocialParams, successCallback : @escaping (Response<User>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SocialLogin(params),
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
