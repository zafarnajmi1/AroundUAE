//
//  ConversationModel.swift
//  HelloStream
//
//  Created by iOSDev on 6/21/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//


import Foundation


public class ConversationModel {
    public var success : Bool?
    public var message : String?
    public var data : ConversationData?
    public var errors : ConversationErrors?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ConversationModel]
    {
        var models:[ConversationModel] = []
        for item in array
        {
            models.append(ConversationModel(dictionary: item as! NSDictionary)!)
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
        if (dictionary["data"] != nil) { data = ConversationData(dictionary: dictionary["data"] as! NSDictionary) }
        if (dictionary["errors"] != nil) { errors = ConversationErrors(dictionary: dictionary["errors"] as! NSDictionary) }
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

public class ConversationData {
    public var conversations : Array<Conversations>?
    public var pagination : ConversationPagination?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ConversationData]
    {
        var models:[ConversationData] = []
        for item in array
        {
            models.append(ConversationData(dictionary: item as! NSDictionary)!)
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
        
        if (dictionary["conversations"] != nil) { conversations = Conversations.modelsFromDictionaryArray(array: dictionary["conversations"] as! NSArray) }
        if (dictionary["pagination"] != nil) { pagination = ConversationPagination(dictionary: dictionary["pagination"] as! NSDictionary) }
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

public class ConversationErrors {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let errors_list = Errors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Errors Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ConversationErrors]
    {
        var models:[ConversationErrors] = []
        for item in array
        {
            models.append(ConversationErrors(dictionary: item as! NSDictionary)!)
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

public class Conversations {
    public var _id : String?
    public var user : UserCon?
    public var store : StoreCon?
    public var createdAt : String?
    public var updatedAt : String?
    public var __v : Int?
    public var lastMessage : LastMessage?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let conversations_list = Conversations.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Conversations Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Conversations]
    {
        var models:[Conversations] = []
        for item in array
        {
            models.append(Conversations(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let conversations = Conversations(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Conversations Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        if (dictionary["user"] != nil) { user = UserCon(dictionary: dictionary["user"] as! NSDictionary) }
        if (dictionary["store"] != nil) { store = StoreCon(dictionary: dictionary["store"] as! NSDictionary) }
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        __v = dictionary["__v"] as? Int
        
        if (dictionary["lastMessage"] as? AnyObject is NSNull){
            
            print("test")
        }
        else{
            if (dictionary["lastMessage"] != nil) { lastMessage = LastMessage(dictionary: dictionary["lastMessage"] as! NSDictionary) }

        }
        
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
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.lastMessage?.dictionaryRepresentation(), forKey: "lastMessage")
        
        return dictionary
    }
    
}


public class ConversationPagination {
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
    public class func modelsFromDictionaryArray(array:NSArray) -> [ConversationPagination]
    {
        var models:[ConversationPagination] = []
        for item in array
        {
            models.append(ConversationPagination(dictionary: item as! NSDictionary)!)
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

public class UserCon {
    public var _id : String?
    public var fullName : String?
    public var image : String?
    public var createdAt : String?
    public var updatedAt : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let person1_list = Person1.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Person1 Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserCon]
    {
        var models:[UserCon] = []
        for item in array
        {
            models.append(UserCon(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let person1 = Person1(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Person1 Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        fullName = dictionary["fullName"] as? String
        image = dictionary["image"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.fullName, forKey: "fullName")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        
        return dictionary
    }
    
}

public class StoreCon {
    public var _id : String?
    public var storeName : StoreNameCon?
    
    

    public var image : String?
    public var createdAt : String?
    public var updatedAt : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let person2_list = Person2.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Person2 Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreCon]
    {
        var models:[StoreCon] = []
        for item in array
        {
            models.append(StoreCon(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let person2 = Person2(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Person2 Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        if (dictionary["storeName"] != nil) { storeName = StoreNameCon(dictionary: dictionary["storeName"] as! NSDictionary) }
        
        
        image = dictionary["image"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.storeName?.dictionaryRepresentation(), forKey: "storeName")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        
        return dictionary
    }
    
}

public class LastMessage {
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
     let lastMessage_list = LastMessage.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of LastMessage Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [LastMessage]
    {
        var models:[LastMessage] = []
        for item in array
        {
            models.append(LastMessage(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let lastMessage = LastMessage(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: LastMessage Instance.
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
public class StoreNameCon {
    public var en : String?
    public var ar : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let title_list = Title.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Title Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreNameCon]
    {
        var models:[StoreNameCon] = []
        for item in array
        {
            models.append(StoreNameCon(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let title = Title(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Title Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        en = dictionary["en"] as? String
        ar = dictionary["ar"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.en, forKey: "en")
        dictionary.setValue(self.ar, forKey: "ar")
        
        return dictionary
    }
    
}
