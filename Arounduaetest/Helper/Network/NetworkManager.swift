//
//  File.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 30/01/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Moya
import Alamofire
import SystemConfiguration



class NetworkManager {
    
    lazy var authPlugin = AccessTokenPlugin(tokenClosure: self.tokenClosure())
    lazy var provider:MoyaProvider<ServerAPI> = MoyaProvider<ServerAPI>(manager: DefaultAlamofireManager.sharedManager,plugins: [authPlugin])
    
    static let networkError = NetworkError(status: Constants.NetworkError.parsing,message: Constants.NetworkError.parsingError)
    
    //MARK: - Token Closure
    let tokenClosure: () -> String = {
        return AppSettings.sharedSettings.authToken ?? ""
    }
    
    init(){
        //MARK: - Token Plugin
        
    }
    
    //MARK: - Network Checker
    static var isAvailable: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
  
    //MARK: - Request
     static func request(target: ServerAPI, success successCallback: @escaping (Data) -> Void, failure failureCallback: @escaping (NetworkError) -> Void, progress progressCallback: ((Double)-> Void)? = nil) {
     if isAvailable {
        NetworkManager().provider.request(target, callbackQueue: nil,
                         
        progress:{(progress) in
            progressCallback?(progress.progress)
        }){(result) in
            
            switch result {
                case .success(let response):
                   
                    if 200..<299 ~= response.statusCode {
                         successCallback(response.data)
                    }else{
                        let networkError = NetworkError()
                        failureCallback(networkError)
                    }
                
                case .failure(let error):
                    var networkError = NetworkError()
                    
                    if error._code == NSURLErrorTimedOut {
                        networkError.status = Constants.NetworkError.timout
                        networkError.message = Constants.NetworkError.timoutError
                        failureCallback(networkError)
                    } else {
                        networkError.status = Constants.NetworkError.generic
                        networkError.message = Constants.NetworkError.genericError
                        failureCallback(networkError)
                     }
                 }
             }
         }else {
             let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
             failureCallback(networkError)
        }
    }
}

struct NetworkError {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}

struct NetworkSuccess {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}
