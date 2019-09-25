
import Foundation

struct Product : Decodable {
    let _id : String?
    let productName : ProductName?
    let description : Description?
    let about : About?
    let reviews : [Reviews]?
    let hasCombinations : Bool?
    let price : ProdyctPrice?
    let available : Int?
    let combinations : [Combinations]?
    let images : [ProductImage]?
    let priceables : [Priceables]?
    let isFavourite : Bool?
    let canReviewUsers: [CanReviewUsers]?
    let store: ProductStore?
    
}


struct Reviews : Decodable {
    let _id : String?
    let rating : Double?
    let comment : String?
    let user : User?
    let createdAt : String?
}

struct About : Decodable {
    let en : String?
    let ar : String?
}

struct Characteristics : Decodable {
    let _id : String?
    let title : Title?
    let image: String?
}

struct Combinations : Decodable {
    let features : [String]?
    let characteristics : [String]?
    let price : Price?
    let avalaible : Int?
    let _id : String?
    let images : [ProductImage]?
}

struct Description : Decodable {
    let en : String?
    let ar : String?
}

struct Feature : Decodable {
    let _id : String?
    let title : Title?
}

struct ProductImage : Codable {
    let path : String?
    let isDefault : Bool?
    let _id : String?
}
struct Images : Decodable {
    let path : String?
}

struct Price : Decodable {
    let usd : Int?
    let aed : Double?
}

struct ProdyctPrice : Decodable {
    let usd : Int?
    let aed : Double?
}

struct Priceables : Decodable {
    let characteristics : [Characteristics]?
    let feature : Feature?
    let _id : String?
}

struct ProductName : Decodable {
    let en : String?
    let ar : String?
}

struct Title : Decodable {
    var en : String?
    var ar : String?
}

struct FavouriteProductData : Decodable {
    let products : [Products]?
    let pagination : Pagination?
}

struct Products: Decodable {
    var _id : String?
    var productName : ProductName?
    var averageRating : Double?
    var images : [Images]?
    var price : Price?
    var minPrice: Int?
    var maxPrice: Int?
    var avalaible: Int?
    var reserved: Int?
    var sold: Int?
    var isFavourite: Bool?
    var onlineSaleable: Bool?
    var isNear: String?
}

struct SearchProductData : Decodable {
    let products : [Products]?
    let pagination : Pagination?
}

struct FeatureCharacterData : Decodable {
    let title : Title?
    let characteristics : [Characteristics]?
    let _id : String?
}

struct featureandcharacterticsData : Decodable {
    let features : [Features]?
}

struct CombinatonTotal:Decodable{
    let usd : Int?
    let aed : Double?
}

struct CombinatonData: Decodable{
    let _id : String?
    let features : [String]?
    let characteristics : [String]?
    let quantity : Int?
    let price : Price?
    let total : CombinatonTotal?
    let product : String?
    let user : String?
    let combination : String?
    let store : String?
    let createdAt : String?
    let updatedAt : String?
}
