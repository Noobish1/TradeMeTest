import Foundation

internal struct CategoryViewModel {
    internal let name: String
    
    internal init(category: Category) {
        // It seems like you do this in the Trade Me app unless the names are different in the production endpoint
        // I decided to copy what the existing app does
        self.name = category.name.replacingOccurrences(of: "Trade Me ", with: "")
    }
}
