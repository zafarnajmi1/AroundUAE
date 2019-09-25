
import Foundation

struct Index : Decodable {
	let settings : Settings?
	let pages : [Pages]?
	let sliders : [Sliders]?
    
    static func getDefaultObject()->Index{
        return Index(settings: nil, pages: nil, sliders: nil)
    }
}

struct AboutShortDescription : Decodable {
    let en : String?
    let ar : String?
}

struct Detail : Decodable {
    let en : String?
    let ar : String?
}

struct Pages : Decodable {
    let title : Title?
    let detail : Detail?
    let image : String?
    let icon : String?
    let _id : String?
}

struct Settings : Decodable {
    let aboutShortDescription : AboutShortDescription?
    let contactEmail : String?
    let emailSenderName : String?
    let emailFrom : String?
    let facebook : String?
    let twitter : String?
    let instagram : String?
    let linkedin : String?
    let location : String?
    let latitude : String?
    let longitude : String?
    let createdAt : String?
    let _id : String?
    let contactNumber : String?
    let updatedAt : String?
    
    static func getDefaultObject()->Settings{
        return Settings(aboutShortDescription: nil, contactEmail: nil, emailSenderName: nil, emailFrom: nil, facebook: nil, twitter: nil, instagram: nil, linkedin: nil, location: nil, latitude: nil, longitude: nil, createdAt: nil, _id: nil, contactNumber: nil, updatedAt: nil)
    }
}

struct Sliders : Decodable {
    let title : Title?
    let image : String?
    let _id : String?
}


