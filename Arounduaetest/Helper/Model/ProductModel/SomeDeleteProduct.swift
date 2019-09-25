
import Foundation

public class SomeDeleteProduct {
    
	public var product : String?
	public var combination : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SomeDeleteProduct]
    {
        var models:[SomeDeleteProduct] = []
        for item in array
        {
            models.append(SomeDeleteProduct(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		product = dictionary["product"] as? String
		combination = dictionary["combination"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.product, forKey: "product")
		dictionary.setValue(self.combination, forKey: "combination")

		return dictionary
	}

}
