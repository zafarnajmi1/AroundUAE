
import Foundation

struct User : Decodable {
	let userType : String?
	let accountType : String?
	let stores : [String]?
	let favouritePlaces : [String]?
	let favouriteProducts : [String]?
	var gender : String?
	let image : String?
	let isCartProcessing : Bool?
	var nic : String?
	let isActive : Bool?
	var isEmailVerified : Bool?
	let _id : String?
	var fullName : String?
	var email : String?
	var phone : String?
	var address : String?
	let createdAt : String?
	let updatedAt : String?
	let addresses : [Addresses]?
	let authorization : String?
    let tradeLicense : String?
    let isTradeLiceseAccepted : Bool?
    static let object = User(userType: nil, accountType: nil, stores: nil, favouritePlaces: nil, favouriteProducts: nil , gender: nil, image: nil, isCartProcessing: nil, nic: nil, isActive: nil, isEmailVerified: nil, _id: nil, fullName: nil, email: nil, phone: nil, address: nil, createdAt: nil, updatedAt: nil, addresses: nil, authorization: nil,tradeLicense: nil, isTradeLiceseAccepted: nil)

}

struct Addresses : Decodable {
    let email : String?
    let phone : String?
    let address1 : String?
    let address2 : String?
    let address3 : String?
    let addressType : String?
    let _id : String?
    let fullName : String?
}

