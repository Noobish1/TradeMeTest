import UIKit

// MARK: ViewWithAContentViewProtocol
internal protocol ViewWithAContentViewProtocol: class {
    var contentView: UIView { get }
}

// MARK: built-in types
extension UITableViewCell: ViewWithAContentViewProtocol {}
extension UICollectionViewCell: ViewWithAContentViewProtocol {}
