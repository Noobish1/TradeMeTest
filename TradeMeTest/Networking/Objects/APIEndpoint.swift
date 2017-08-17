import Foundation
import enum KeyedAPIParameters.HTTPMethod
import Alamofire

// MARK: - APIEndpoint
internal enum APIEndpoint {
    case rootCategories
    case category(Int)
    case search
    
    internal var url: String {
        switch self {
            case .rootCategories: return "Categories/0.json"
            case .category(let category): return "Categories/\(category).json"
            case .search: return "Search/General.json"
        }
    }
    
    internal var method: KeyedAPIParameters.HTTPMethod {
        switch self {
            case .rootCategories, .category, .search: return .get
        }
    }
    
    internal var apiVersion: String {
        return "v1"
    }
}
