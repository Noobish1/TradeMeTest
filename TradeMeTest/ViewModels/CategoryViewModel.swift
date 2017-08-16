import Foundation

internal struct CategoryViewModel {
    internal let name: String
    
    internal init(category: Category) {
        self.name = category.name
    }
}
