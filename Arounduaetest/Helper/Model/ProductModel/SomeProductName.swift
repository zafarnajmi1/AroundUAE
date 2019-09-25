
import Foundation

public class SomeProductName {
	public var en : String?
	public var ar : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SomeProductName]
    {
        var models:[SomeProductName] = []
        for item in array
        {
            models.append(SomeProductName(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		en = dictionary["en"] as? String
		ar = dictionary["ar"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.en, forKey: "en")
		dictionary.setValue(self.ar, forKey: "ar")

		return dictionary
	}

}
