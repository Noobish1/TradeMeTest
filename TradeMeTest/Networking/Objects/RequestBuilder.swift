import Foundation
import Alamofire
import KeyedAPIParameters

internal struct RequestBuilderDependencies {
    internal let baseURLString: String
    internal let requestManager: SessionManager
    
    internal static var `default`: RequestBuilderDependencies {
        return RequestBuilderDependencies(baseURLString: Environment.Variables.BaseURLString,
                                          requestManager: RequestBuilder.manager)
    }
}

internal final class RequestBuilder {
    private static let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    private static let consumerSecret = "EC7F18B17A062962C6930A8AE88B16C7"
    fileprivate static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let newManager = SessionManager(configuration: configuration)
        newManager.startRequestsImmediately = false
        
        return newManager
    }()
    
    internal static let defaultHeaders = [
        "Accept" : "application/json",
        "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"\(consumerSecret)&\""
    ]
    
    internal class func buildRequest(for endpoint: APIEndpoint, params: APIParameters? = nil,
                                     dependencies: RequestBuilderDependencies = .default) -> DataRequest {
        let URLString = "\(dependencies.baseURLString)/\(endpoint.apiVersion)/"
        
        guard var URL = URL(string: URLString) else {
            fatalError("Could not create a URL from \(URLString)")
        }
        
        if !endpoint.url.isEmpty {
            URL.appendPathComponent(endpoint.url)
        }
        
        return dependencies.requestManager.request(URL,
                                                   method: endpoint.method.asAlamofireHTTPMethod(),
                                                   parameters: params?.toDictionary(forHTTPMethod: endpoint.method),
                                                   encoding: endpoint.method == .get ? URLEncoding() : JSONEncoding(),
                                                   headers: defaultHeaders)
    }
}
