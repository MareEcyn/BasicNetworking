import Foundation

struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
    
    enum CodingKeys: String, CodingKey {
        case items = "records"
    }
}

struct Image: Decodable {
    let id: Int
    let date: String
    let URL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "imageid"
        case URL = "baseimageurl"
        case date
    }
}
