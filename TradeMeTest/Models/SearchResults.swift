import Foundation
import KeyedMapper

internal struct SearchResults {
    internal let listings: [Listing]
}

extension SearchResults: Mappable {
    internal enum Key: String, JSONKey {
        case listings = "List"
    }
    
    internal init(map: KeyedMapper<SearchResults>) throws {
        self.listings = try map.from(.listings)
    }
}
