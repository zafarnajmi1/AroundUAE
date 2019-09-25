
import Foundation

public class ProductUAE {
    
	public var _id : String?
	public var quantity : Double?
	public var price : SomePrice?
	public var total : Total?
	public var product : SomeProduct?
	public var combination : String?
    public var image: String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductUAE]{
        var models:[ProductUAE] = []
        for item in array{
            models.append(ProductUAE(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		_id = dictionary["_id"] as? String
		quantity = dictionary["quantity"] as? Double
		if (dictionary["price"] != nil) { price = SomePrice(dictionary: dictionary["price"] as! NSDictionary) }
		if (dictionary["total"] != nil) { total = Total(dictionary: dictionary["total"] as! NSDictionary) }
		if (dictionary["product"] != nil) { product = SomeProduct(dictionary: dictionary["product"] as! NSDictionary) }
		combination = dictionary["combination"] as? String
        image = dictionary["image"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.quantity, forKey: "quantity")
		dictionary.setValue(self.price?.dictionaryRepresentation(), forKey: "price")
		dictionary.setValue(self.total?.dictionaryRepresentation(), forKey: "total")
		dictionary.setValue(self.product?.dictionaryRepresentation(), forKey: "product")
		dictionary.setValue(self.combination, forKey: "combination")
        dictionary.setValue(self.image, forKey: "image")

		return dictionary
	}
}
