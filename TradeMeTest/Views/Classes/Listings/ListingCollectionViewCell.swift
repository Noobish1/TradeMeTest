import UIKit
import Kingfisher

internal final class ListingCollectionViewCellContentView: UIView, NibCreatable {
    // MARK: outlets
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
}

internal final class ListingCollectionViewCell: CustomCollectionViewCell<ListingCollectionViewCellContentView> {
    
    // MARK: update
    internal func update(with viewModel: ListingViewModel) {
        innerContentView.titleLabel.text = viewModel.title
        innerContentView.imageView.kf.setImage(with: viewModel.imageURL)
    }
}