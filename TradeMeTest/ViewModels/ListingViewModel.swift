import Foundation

internal struct ListingViewModel {
    // MARK: properties
    internal let id: String
    internal let title: String
    internal let imageURL: URL?
    
    // MARK: init/deinit
    internal init(listing: Listing) {
        self.id = String(describing: listing.id)
        self.title = listing.title
        self.imageURL = listing.imageURLString.flatMap(URL.init)
    }
}
