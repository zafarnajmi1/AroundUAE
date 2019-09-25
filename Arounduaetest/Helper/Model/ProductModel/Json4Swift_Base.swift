
import Foundation

public class Json4Swift_Base {
    
     var success : Bool?
	 var message : SomeMessage?
	 var data : Array<ProductUAE>?
	 var errors : Errors?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Json4Swift_Base]{
        var models:[Json4Swift_Base] = []
        for item in array
        {
            models.append(Json4Swift_Base(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? Bool
		if (dictionary["message"] != nil) { message = SomeMessage(dictionary: dictionary["message"] as! NSDictionary) }
        if (dictionary["data"] != nil) { data = ProductUAE.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
		
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message?.dictionaryRepresentation(), forKey: "message")
		

		return dictionary
	}
}
