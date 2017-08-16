import Foundation
import KeyedMapper

internal struct Category {
    internal let name: String
    internal let subcategories: [Category]
}

extension Category: Mappable {
    internal enum Key: String, JSONKey {
        case name = "Name"
        case subcategories = "Subcategories"
    }
    
    internal init(map: KeyedMapper<Category>) throws {
        self.name = try map.from(.name)
        self.subcategories = map.optionalFrom(.subcategories) ?? []
    }
}
