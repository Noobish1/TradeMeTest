import Foundation
import KeyedMapper

// MARK: Listing
internal struct Listing {
    internal let id: Int
    internal let title: String
    internal let imageURLString: String?
}

// MARK: Mappable
extension Listing: Mappable {
    internal enum Key: String, JSONKey {
        case id = "ListingId"
        case title = "Title"
        case imageURLString = "PictureHref"
    }
    
    internal init(map: KeyedMapper<Listing>) throws {
        self.id = try map.from(.id)
        self.title = try map.from(.title)
        self.imageURLString = map.optionalFrom(.imageURLString)
    }
}
