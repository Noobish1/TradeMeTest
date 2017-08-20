import Foundation
import KeyedMapper

// MARK: Listing
internal struct Listing {
    internal let title: String
    internal let imageURLString: String?
}

// MARK: Mappable
extension Listing: Mappable {
    internal enum Key: String, JSONKey {
        case title = "Title"
        case imageURLString = "PictureHref"
    }
    
    internal init(map: KeyedMapper<Listing>) throws {
        self.title = try map.from(.title)
        self.imageURLString = map.optionalFrom(.imageURLString)
    }
}
