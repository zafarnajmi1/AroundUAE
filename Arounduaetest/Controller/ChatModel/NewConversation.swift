//
//  NewConversation.swift
//  Rent Cars
//
//  Created by Apple on 16/08/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//


import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class NewConversation {
    public var success : Bool?
    public var message : String?
    public var data : NewData?
    public var errors : ErrorsNewChat?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewConversation]
    {
        var models:[NewConversation] = []
        for item in array
        {
            models.append(NewConversation(dictionary: item as! NSDictionary)!)
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
        if (dictionary["data"] != nil) { data = NewData(dictionary: dictionary["data"] as! NSDictionary) }
        if (dictionary["errors"] != nil) { errors = ErrorsNewChat(dictionary: dictionary["errors"] as! NSDictionary) }
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

public class NewData {
    public var conversation : Conversation?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewData]
    {
        var models:[NewData] = []
        for item in array
        {
            models.append(NewData(dictionary: item as! NSDictionary)!)
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
        
        if (dictionary["conversation"] != nil) { conversation = Conversation(dictionary: dictionary["conversation"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.conversation?.dictionaryRepresentation(), forKey: "conversation")
        
        return dictionary
    }
    
}


public class ErrorsNewChat {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let errors_list = Errors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Errors Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ErrorsNewChat]
    {
        var models:[ErrorsNewChat] = []
        for item in array
        {
            models.append(ErrorsNewChat(dictionary: item as! NSDictionary)!)
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

public class Conversation {
    public var _id : String?
    public var user : UserCon?
    public var store : StoreCon?
    public var lastMessage : String?
    public var createdAt : String?
    public var updatedAt : String?
    public var __v : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let conversation_list = Conversation.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Conversation Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Conversation]
    {
        var models:[Conversation] = []
        for item in array
        {
            models.append(Conversation(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let conversation = Conversation(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Conversation Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        if (dictionary["user"] != nil) { user = UserCon(dictionary: dictionary["user"] as! NSDictionary) }
        if (dictionary["person2"] != nil) { store = StoreCon(dictionary: dictionary["store"] as! NSDictionary) }
        lastMessage = dictionary["lastMessage"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        __v = dictionary["__v"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")
        dictionary.setValue(self.store?.dictionaryRepresentation(), forKey: "store")
        dictionary.setValue(self.lastMessage, forKey: "lastMessage")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        dictionary.setValue(self.__v, forKey: "__v")
        
        return dictionary
    }
    
}

