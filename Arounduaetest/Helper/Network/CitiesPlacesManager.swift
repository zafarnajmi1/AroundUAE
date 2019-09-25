//
//  CitiesPlacesManager.swift
//  Arounduaetest
//
//  Created by mohsin raza on 23/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

class CitiesPlacesManager{
    
    //MARK: - GetEvents
    func getEvents(_ params:CityEventsParams,successCallback : @escaping (Response<EventsData>?) -> Void,
                   failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .CityEvents(params),
                               success:
            {(response) in
//                do {
                
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                    //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                    print("Get Events Response :\(json)")
//                }
//                catch (let error){
//                    print("Error :\(error)")
//                }
                
                if let parsedResponse = ServerAPI.parseServerResponse(Response<EventsData>.self, from: response){
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
    //MARK: - Event Detail
    func getEventDetail(_ eventID:String,successCallback : @escaping (Response<EventDetail>?) -> Void,
                   failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .EventDetail(eventID: eventID),
                               success:
            {(response) in
                //                do {
                
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                print("Get Events Response :\(json)")
                //                }
                //                catch (let error){
                //                    print("Error :\(error)")
                //                }
                
                if let parsedResponse = ServerAPI.parseServerResponse(Response<EventDetail>.self, from: response){
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
    //MARK: - Add Event
    
    /*
     func addEvent(_ params:AddEventParams,successCallback : @escaping (Response<EventDetail>?) -> Void,
     failureCallback : @escaping (NetworkError) -> Void, progressCallback: ((Double)-> Void)? = nil){
     
     NetworkManager.request(target: .AddEvent(params), success: {(response) in
     //                do {
     
     let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
     //                let json = JSONSerialization.JSONObjectWithData(response, options: )
     print("Add Events Response :\(json)")
     //                }
     //                catch (let error){
     //                    print("Error :\(error)")
     //                }
     
     if let parsedResponse = ServerAPI.parseServerResponse(Response<EventDetail>.self, from: response){
     successCallback(parsedResponse)
     }else{
     failureCallback(NetworkManager.networkError)
     }
     }, failure: {(error) in
     print("Error :\(error)")
     failureCallback(error)
     }) { (progress) in
     
     if let progressCallback = progressCallback {
     progressCallback(progress)
     }
     
     
     }
     */
    
    func addEvent(_ params:AddEventParams,successCallback : @escaping (Response<EventDetail>?) -> Void,
                   failureCallback : @escaping (NetworkError) -> Void){
          print(params.email)
        NetworkManager.request(target: .AddEvent(params),
                               success:
            {(response) in
                //                do {
                
                let json = NSString(data: response, encoding: String.Encoding.utf8.rawValue)! as String
                //                let json = JSONSerialization.JSONObjectWithData(response, options: )
                print("Add Events Response :\(json)")
                //                }
                //                catch (let error){
                //                    print("Error :\(error)")
                //                }
                
                if let parsedResponse = ServerAPI.parseServerResponse(Response<EventDetail>.self, from: response){
                    successCallback(parsedResponse)
                }else{
                    failureCallback(NetworkManager.networkError)
                }
        },
                               failure:
            {(error) in
                print("Error :\(error)")
                failureCallback(error)
        })
    }
    
    //MARK: - GetCities
    func getCities(_ pageno:String,successCallback : @escaping (Response<CitiesData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCities(pageNo: pageno),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<CitiesData>.self, from: response){
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
    
    //MARK: - GetCitiesPlaces
    func getCitiesPlaces(_ params:CitiesPlacesParams,successCallback : @escaping (Response<PlacesData>?) -> Void,
       failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .CitiesPlaces(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<PlacesData>.self, from: response){
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
    
    //MARK: - GetFavouritePlacesList
    func getFavouritePlacesList(_ pageno:String ,successCallback : @escaping (Response<PlacesData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .FavouritePlacesList(pageNo: pageno),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<PlacesData>.self, from: response){
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
    
    //MARK: - MAKE PLACE FAVOURITE
    func makePlaceFavourite(_ placeid:String ,successCallback : @escaping (Response<User>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .MakePlaceFavourite(placeId: placeid),
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
    
    //MARK: - MAKE PLACE FAVOURITE
    func getPlaceDetail(_ placeid:String ,successCallback : @escaping (Response<Places>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .PlaceDetail(placeId: placeid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Places>.self, from: response){
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
    func submitPlaceReview(_ params:SubmitPlaceReviewParams ,successCallback : @escaping (Response<placeReview>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SubmitPlaceReview(params),
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
}
