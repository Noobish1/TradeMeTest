import Foundation
import KeyedMapper

internal struct Listing {
    internal let title: String
    internal let imageURLString: String
}

extension Listing: Mappable {
    internal enum Key: String, JSONKey {
        case title = "Title"
        case imageURLString = "PictureHref"
    }
    
    internal init(map: KeyedMapper<Listing>) throws {
        self.title = try map.from(.title)
        self.imageURLString = try map.from(.imageURLString)
    }
}
