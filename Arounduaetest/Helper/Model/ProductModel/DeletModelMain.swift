
import Foundation

public class DeletModelMain {
    
    var success : Bool?
    var message : SomeMessage?
    var data : SomeDeleteProduct?
    var errors : Errors?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [DeletModelMain]{
        var models:[DeletModelMain] = []
        for item in array
        {
            models.append(DeletModelMain(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        
        success = dictionary["success"] as? Bool
        if (dictionary["message"] != nil) { message = SomeMessage(dictionary: dictionary["message"] as! NSDictionary) }
        if (dictionary["data"] != nil) { data = SomeDeleteProduct(dictionary: dictionary["data"] as! NSDictionary) }
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.message?.dictionaryRepresentation(), forKey: "message")
        
        
        return dictionary
    }
}
