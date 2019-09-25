//
//  ChatModel.swift
//  HelloStream
//
//  Created by iOSDev on 6/22/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//


import Foundation


public class ChatModel {
    public var success : Bool?
    public var message : String?
    public var data : ChatData?
    public var errors :ChatErrors?
    
  
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChatModel]
    {
        var models:[ChatModel] = []
        for item in array
        {
            models.append(ChatModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
 
    required public init?(dictionary: NSDictionary) {
        
        success = dictionary["success"] as? Bool
        message = dictionary["message"] as? String
        if (dictionary["data"] != nil) { data = ChatData(dictionary: dictionary["data"] as! NSDictionary) }
        if (dictionary["errors"] != nil) { errors = ChatErrors(dictionary: dictionary["errors"] as! NSDictionary) }
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


public class ChatData {
    public var messages : Array<Messages>?

    public var pagination : Paginations?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChatData]
    {
        var models:[ChatData] = []
        for item in array
        {
            models.append(ChatData(dictionary: item as! NSDictionary)!)
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

        if (dictionary["messages"] != nil) { messages = Messages.modelsFromDictionaryArray(array: dictionary["messages"] as! NSArray) }
        if (dictionary["pagination"] != nil) { pagination = Paginations(dictionary: dictionary["pagination"] as! NSDictionary) }
        
      

    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.pagination?.dictionaryRepresentation(), forKey: "pagination")

        return dictionary
    }
    
}

public class ChatErrors {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let errors_list = Errors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Errors Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChatErrors]
    {
        var models:[ChatErrors] = []
        for item in array
        {
            models.append(ChatErrors(dictionary: item as! NSDictionary)!)
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


public class Messages {
    public var _id : String?
    public var mimeType : String?
    public var conversation : String?
    public var sender : String?
    public var createdAt : String?
    public var updatedAt : String?
    public var content : String?
    public var __v : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let messages_list = Messages.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Messages Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Messages]
    {
        var models:[Messages] = []
        for item in array
        {
            models.append(Messages(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let messages = Messages(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Messages Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        mimeType = dictionary["mimeType"] as? String
        conversation = dictionary["conversation"] as? String
        sender = dictionary["sender"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        content = dictionary["content"] as? String
        __v = dictionary["__v"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.mimeType, forKey: "mimeType")
        dictionary.setValue(self.conversation, forKey: "conversation")
        dictionary.setValue(self.sender, forKey: "sender")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        dictionary.setValue(self.content, forKey: "content")
        dictionary.setValue(self.__v, forKey: "__v")
        
        return dictionary
    }
    
}

public class Paginations {
    public var total : Int?
    public var pages : Int?
    public var per_page : Int?
    public var page : Int?
    public var previous : Int?
    public var next : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let pagination_list = Pagination.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Pagination Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Paginations]
    {
        var models:[Paginations] = []
        for item in array
        {
            models.append(Paginations(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let pagination = Pagination(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Pagination Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        total = dictionary["total"] as? Int
        pages = dictionary["pages"] as? Int
        per_page = dictionary["per_page"] as? Int
        page = dictionary["page"] as? Int
        previous = dictionary["previous"] as? Int
        next = dictionary["next"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.total, forKey: "total")
        dictionary.setValue(self.pages, forKey: "pages")
        dictionary.setValue(self.per_page, forKey: "per_page")
        dictionary.setValue(self.page, forKey: "page")
        dictionary.setValue(self.previous, forKey: "previous")
        dictionary.setValue(self.next, forKey: "next")
        
        return dictionary
    }
    
}
