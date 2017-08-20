import UIKit

internal struct CategoryViewModel {
    // MARK: properties
    internal let name: String
    internal let number: String
    internal let hasSubcategories: Bool
    internal let subcategoires: [CategoryViewModel]
    // MARK: computed properties
    internal var accessoryType: UITableViewCellAccessoryType {
        return hasSubcategories ? .disclosureIndicator : .none
    }
    
    // MARK: init/deinit
    internal init(name: String? = nil, category: Category) {
        // It seems like you do this in the Trade Me app unless the names are different in the production endpoint
        // I decided to copy what the existing app does
        self.name = name ?? category.name.replacingOccurrences(of: "Trade Me ", with: "")
        self.number = category.number
        self.hasSubcategories = !category.subcategories.isEmpty
        self.subcategoires = category.subcategories.map { CategoryViewModel(category: $0) }
    }
}
