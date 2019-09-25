//
//  NotificationCountModel .swift
//  ValetParking
//
//  Created by My Technology on 17/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation


public class NotificationCountModel {
    public var success : Bool?
    public var message : String?
    public var data : NotificationCountData?
    public var errors :  NotificationCountErrors?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationCountModel]
    {
        var models:[NotificationCountModel] = []
        for item in array
        {
            models.append(NotificationCountModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        success = dictionary["success"] as? Bool
        message = dictionary["message"] as? String
        if (dictionary["data"] != nil) { data = NotificationCountData(dictionary: dictionary["data"] as! NSDictionary) }
        if (dictionary["errors"] != nil) { errors = NotificationCountErrors(dictionary: dictionary["errors"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
        dictionary.setValue(self.errors?.dictionaryRepresentation(), forKey: "errors")
        
        return dictionary
    }
    
}

public class NotificationCountData {
    public var unseenNotificationsCount : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationCountData]
    {
        var models:[NotificationCountData] = []
        for item in array
        {
            models.append(NotificationCountData(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let data = Data(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Data Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        unseenNotificationsCount = dictionary["unseenNotificationsCount"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.unseenNotificationsCount, forKey: "unseenNotificationsCount")
        
        return dictionary
    }
    
}

public class NotificationCountErrors {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let errors_list = Errors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Errors Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationCountErrors]
    {
        var models:[NotificationCountErrors] = []
        for item in array
        {
            models.append(NotificationCountErrors(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let errors = Errors(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Errors Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }
    
}
