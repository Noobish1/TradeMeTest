import Foundation
import KeyedAPIParameters

internal struct SearchParams {
    internal let text: String
    internal let imageSize = "List"
}

extension SearchParams: KeyedAPIParameters {
    internal enum Key: String, ParamJSONKey {
        case text = "search_string"
        case imageSize = "photo_size"
    }
    
    internal func toKeyedDictionary() -> [Key : APIParamValue] {
        return [.text : .convertible(text), .imageSize : .convertible(imageSize)]
    }
}
