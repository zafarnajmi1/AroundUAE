/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct SomeData : Mappable {
	var userType : String?
	var accountType : String?
	var stores : [String]?
	var favouritePlaces : [String]?
	var favouriteProducts : [String]?
	var gender : String?
	var image : String?
	var isCartProcessing : Bool?
	var nic : String?
	var isActive : Bool?
	var isEmailVerified : Bool?
	var addresses : [String]?
	var _id : String?
	var fullName : String?
	var email : String?
	var phone : String?
	var address : String?
	var createdAt : String?
	var updatedAt : String?
	var authorization : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		userType <- map["userType"]
		accountType <- map["accountType"]
		stores <- map["stores"]
		favouritePlaces <- map["favouritePlaces"]
		favouriteProducts <- map["favouriteProducts"]
		gender <- map["gender"]
		image <- map["image"]
		isCartProcessing <- map["isCartProcessing"]
		nic <- map["nic"]
		isActive <- map["isActive"]
		isEmailVerified <- map["isEmailVerified"]
		addresses <- map["addresses"]
		_id <- map["_id"]
		fullName <- map["fullName"]
		email <- map["email"]
		phone <- map["phone"]
		address <- map["address"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		authorization <- map["authorization"]
	}

}
