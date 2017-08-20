import Foundation
import Alamofire
import KeyedAPIParameters

internal final class RequestBuilder {
    // MARK: constants
    private static let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    private static let consumerSecret = "EC7F18B17A062962C6930A8AE88B16C7"
    private static let defaultHeaders = [
        "Accept" : "application/json",
        "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"\(consumerSecret)&\""
    ]
    // MARK: properties
    fileprivate static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let newManager = SessionManager(configuration: configuration)
        newManager.startRequestsImmediately = false
        
        return newManager
    }()
    
    // MARK: building requests
    internal class func buildRequest(for endpoint: APIEndpoint,
                                     params: APIParameters? = nil,
                                     baseURLString: String = Environment.Variables.BaseURLString) -> DataRequest {
        let URLString = "\(baseURLString)/\(endpoint.apiVersion)/"
        
        guard var URL = URL(string: URLString) else {
            fatalError("Could not create a URL from \(URLString)")
        }
        
        if !endpoint.url.isEmpty {
            URL.appendPathComponent(endpoint.url)
        }
        
        return manager.request(URL,
                               method: endpoint.method.asAlamofireHTTPMethod(),
                               parameters: params?.toDictionary(forHTTPMethod: endpoint.method),
                               encoding: endpoint.method == .get ? URLEncoding() : JSONEncoding(),
                               headers: defaultHeaders)
    }
}
