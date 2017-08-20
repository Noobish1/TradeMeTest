import Foundation
import KeyedAPIParameters

// MARK: SearchParams
internal enum SearchParams {
    case searchOnly(String)
    case categoryOnly(String)
    case searchAndCategory(search: String, category: String)
    
    internal var imageSize: String { return "Gallery" }
    internal var numberOfResults: Int { return 20 }
    
    internal init?(search optionalSearch: String?, category optionalCategory: String?) {
        if let search = optionalSearch, !search.isEmpty {
            if let category = optionalCategory, !category.isEmpty {
                self = .searchAndCategory(search: search, category: category)
            } else {
                self = .searchOnly(search)
            }
        } else if let category = optionalCategory, !category.isEmpty {
            self = .categoryOnly(category)
        } else {
            return nil
        }
    }
}

// MARK: KeyedAPIParameters
extension SearchParams: KeyedAPIParameters {
    internal enum Key: String, ParamJSONKey {
        case searchString = "search_string"
        case category
        case imageSize = "photo_size"
        case numberOfResults = "rows"
    }
    
    internal func toKeyedDictionary() -> [Key : APIParamValue] {
        let defaultParams: [Key : APIParamValue] = [
            .imageSize : .convertible(imageSize),
            .numberOfResults : .convertible(numberOfResults)
        ]
        
        switch self {
            case .searchOnly(let search):
                return defaultParams.byUpdating(pairs: [.searchString : .convertible(search)])
            case .categoryOnly(let category):
                return defaultParams.byUpdating(pairs: [.category : .convertible(category)])
            case .searchAndCategory(search: let search, category: let category):
                return defaultParams.byUpdating(pairs: [.searchString : .convertible(search), .category : .convertible(category)])
        }
    }
}

// MARK: Equatable
extension SearchParams: Equatable {
    internal static func == (lhs: SearchParams, rhs: SearchParams) -> Bool {
        switch lhs {
            case .searchOnly(let lhsSearch):
                switch rhs {
                    case .searchOnly(let rhsSearch):
                        return lhsSearch == rhsSearch
                    default: return false
                }
            case .categoryOnly(let lhsCategory):
                switch rhs {
                    case .categoryOnly(let rhsCategory):
                        return lhsCategory == rhsCategory
                    default: return false
                }
            case .searchAndCategory(search: let lhsSearch, category: let lhsCategory):
                switch rhs {
                    case .searchAndCategory(search: let rhsSearch, category: let rhsCategory):
                        return lhsSearch == rhsSearch && lhsCategory == rhsCategory
                    default: return false
                }
        }
    }
}
