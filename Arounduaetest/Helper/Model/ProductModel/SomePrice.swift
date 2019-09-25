

import Foundation

public class SomePrice {
	public var usd : Int?
	public var aed : Double?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SomePrice]
    {
        var models:[SomePrice] = []
        for item in array
        {
            models.append(SomePrice(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		usd = dictionary["usd"] as? Int
		aed = dictionary["aed"] as? Double
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.usd, forKey: "usd")
		dictionary.setValue(self.aed, forKey: "aed")

		return dictionary
	}

}
