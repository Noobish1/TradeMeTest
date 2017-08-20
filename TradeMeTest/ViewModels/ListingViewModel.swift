import Foundation

internal struct ListingViewModel {
    // MARK: properties
    internal let title: String
    internal let imageURL: URL?
    
    // MARK: init/deinit
    internal init(listing: Listing) {
        self.title = listing.title
        self.imageURL = listing.imageURLString.flatMap(URL.init)
    }
}
