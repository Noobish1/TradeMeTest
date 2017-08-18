import UIKit

internal protocol CustomCellProtocol: CustomViewProtocol {
    static var identifier: String { get }
}

internal extension CustomCellProtocol {
    internal static var identifier: String {
        return String(describing: type(of: self))
    }
}

extension CustomCellProtocol where Self: UITableViewCell {
    internal func setupCustomView() {
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(innerContentView)
    }
}

extension CustomCellProtocol where Self: UICollectionViewCell {
    internal func setupCustomView() {
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(innerContentView)
    }
}
