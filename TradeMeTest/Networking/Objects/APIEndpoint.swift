import Foundation
import enum KeyedAPIParameters.HTTPMethod
import Alamofire

// MARK: - APIEndpoint
internal enum APIEndpoint {
    case rootCategories
    case category(Int)
    
    internal var url: String {
        switch self {
            case .rootCategories: return "Categories/0.json"
            case .category(let category): return "Categories/\(category).json"
        }
    }
    
    internal var method: KeyedAPIParameters.HTTPMethod {
        switch self {
            case .rootCategories, .category: return .get
        }
    }
    
    internal var apiVersion: String {
        return "v1"
    }
}
