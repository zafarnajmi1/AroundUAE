//
//  NewMessageModel.swift
//  HelloStream
//
//  Created by iOSDev on 9/25/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//


import Foundation


public class NewMessageModel {
    public var success : Bool?
    public var message : String?
    public var data : NewMessageData?
    public var errors :NewMessageChatErrors?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewMessageModel]
    {
        var models:[NewMessageModel] = []
        for item in array
        {
            models.append(NewMessageModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        
        success = dictionary["success"] as? Bool
        message = dictionary["message"] as? String
        if (dictionary["data"] != nil) { data = NewMessageData(dictionary: dictionary["data"] as! NSDictionary) }
        if (dictionary["errors"] != nil) { errors = NewMessageChatErrors(dictionary: dictionary["errors"] as! NSDictionary) }
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


public class NewMessageData {
  public  var data_new_message : Messages?
    
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewMessageData]
    {
        var models:[NewMessageData] = []
        for item in array
        {
            models.append(NewMessageData(dictionary: item as! NSDictionary)!)
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
        
     
        
        if (dictionary["message"] != nil) { data_new_message = Messages(dictionary: dictionary["message"] as! NSDictionary) }
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.data_new_message?.dictionaryRepresentation(), forKey: "message")
        
        return dictionary
    }
    
}

public class NewMessageChatErrors {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let errors_list = Errors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Errors Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewMessageChatErrors]
    {
        var models:[NewMessageChatErrors] = []
        for item in array
        {
            models.append(NewMessageChatErrors(dictionary: item as! NSDictionary)!)
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

