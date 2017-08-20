import Foundation
import KeyedMapper

// MARK: Category
internal struct Category {
    internal let name: String
    internal let number: String
    internal let subcategories: [Category]
}

// MARK: Mappable
extension Category: Mappable {
    internal enum Key: String, JSONKey {
        case name = "Name"
        case number = "Number"
        case subcategories = "Subcategories"
    }
    
    internal init(map: KeyedMapper<Category>) throws {
        self.name = try map.from(.name)
        self.number = try map.from(.number)
        self.subcategories = map.optionalFrom(.subcategories) ?? []
    }
}
