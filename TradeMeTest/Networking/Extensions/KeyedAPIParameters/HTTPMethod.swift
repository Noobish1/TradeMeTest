import enum KeyedAPIParameters.HTTPMethod
import Alamofire

internal extension KeyedAPIParameters.HTTPMethod {
    internal func asAlamofireHTTPMethod() -> Alamofire.HTTPMethod {
        switch self {
            case .get: return .get
            case .post: return .post
            case .put: return .put
            case .delete: return .delete
        }
    }
}
