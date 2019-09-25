
import Foundation

public class SomeMessage {
	public var ar : String?
	public var en : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SomeMessage]
    {
        var models:[SomeMessage] = []
        for item in array
        {
            models.append(SomeMessage(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		ar = dictionary["ar"] as? String
		en = dictionary["en"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.ar, forKey: "ar")
		dictionary.setValue(self.en, forKey: "en")

		return dictionary
	}

}
