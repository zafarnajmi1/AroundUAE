import Foundation

public class SomeProduct {
    
    public var _id : String?
    public var productName : SomeProductName?
    public var image : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [SomeProduct]
    {
        var models:[SomeProduct] = []
        for item in array
        {
            models.append(SomeProduct(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        if (dictionary["productName"] != nil) { productName = SomeProductName(dictionary: dictionary["productName"] as! NSDictionary) }
        image = dictionary["image"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.productName?.dictionaryRepresentation(), forKey: "productName")
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
}
