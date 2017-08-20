import UIKit
import Kingfisher

// MARK: ListingCollectionViewCellContentView
internal final class ListingCollectionViewCellContentView: UIView, NibCreatable {
    // MARK: outlets
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
}

// MARK: ListingCollectionViewCell
internal final class ListingCollectionViewCell: NibBackedCollectionViewCell<ListingCollectionViewCellContentView> {
    // MARK: update
    internal func update(with viewModel: ListingViewModel) {
        self.applyDefaultBorder()
        
        innerContentView.titleLabel.text = viewModel.title
        innerContentView.imageView.kf.setImage(with: viewModel.imageURL)
    }
}
