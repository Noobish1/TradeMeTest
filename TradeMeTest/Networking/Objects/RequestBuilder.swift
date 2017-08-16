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
    fileprivate static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let newManager = SessionManager(configuration: configuration)
        newManager.startRequestsImmediately = false
        
        return newManager
    }()
    
    internal static let defaultHeaders = ["Accept" : "application/json"]
    
    internal class func buildRequest(for endpoint: APIEndpoint, params: APIParameters? = nil,
                                     dependencies: RequestBuilderDependencies = .default) -> DataRequest {
        let URLString = "\(dependencies.baseURLString)/\(endpoint.apiVersion)/restaurants"
        
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
