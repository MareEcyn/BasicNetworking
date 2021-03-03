import Foundation
import UIKit

// TODO: - Need to implement error handling

enum APICredentials {
    static let endPoint = "https://api.harvardartmuseums.org"
    static let apiKey = "4022211f-b892-451a-870f-9b3e96bf7cfe"
}

// MARK: - Resource
protocol APIResource {
    associatedtype Model: Decodable
    var path: String { get }
    var queryItems: [String: String] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: APICredentials.endPoint)!
        components.path = path
        components.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}

struct ImagesResource: APIResource {
    typealias Model = Image
    let path = "/image"
    let queryItems = [
        "apikey": APICredentials.apiKey,
        "size": "5",
        "sort": "random",
    ]
}

// MARK: - Network request
protocol NetworkRequest: AnyObject {
    associatedtype Model
    func decode(_ data: Data) -> Model?
    func load(withCompletion handler: @escaping (Model?) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion handler: @escaping (Model?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) -> Void in
            guard let data = data else {
                handler(nil)
                return
            }
            let decode = self?.decode(data)
            handler(decode)
        }.resume()
    }
}

class ImageRequest: NetworkRequest {
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(withCompletion handler: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: handler)
    }
}

class APIRequest<Resource: APIResource>: NetworkRequest {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func decode(_ data: Data) -> [Resource.Model]? {
        let wrapper = try? JSONDecoder().decode(Wrapper<Resource.Model>.self, from: data)
        return wrapper?.items
    }
    
    func load(withCompletion handler: @escaping ([Resource.Model]?) -> Void) {
        load(resource.url, withCompletion: handler)
    }
}
