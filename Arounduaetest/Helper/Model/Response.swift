

import Foundation

struct Response<T: Decodable>: Decodable {
    let success : Bool?
    let message : Message?
    let data : T?
    let errors : Errors?
}

