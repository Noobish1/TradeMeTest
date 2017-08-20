import Foundation
import KeyedMapper

// MARK: SearchResults
internal struct SearchResults {
    internal let listings: [Listing]
}

// MARK: Mappable
extension SearchResults: Mappable {
    internal enum Key: String, JSONKey {
        case listings = "List"
    }
    
    internal init(map: KeyedMapper<SearchResults>) throws {
        self.listings = try map.from(.listings)
    }
}
