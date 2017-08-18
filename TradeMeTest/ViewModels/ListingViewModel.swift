import Foundation

internal struct ListingViewModel {
    internal let title: String
    internal let imageURL: URL?
    
    internal init(listing: Listing) {
        self.title = listing.title
        self.imageURL = listing.imageURLString.flatMap(URL.init)
    }
}
