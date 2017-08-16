import Foundation
import UIKit

internal protocol CustomTableViewCellProtocol: CustomViewProtocol {
    static var identifier: String { get }
}

internal extension CustomTableViewCellProtocol {
    internal static var identifier: String {
        return String(describing: type(of: self))
    }
}

extension CustomTableViewCellProtocol where Self: UITableViewCell {
    internal func setupCustomView() {
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(innerContentView)
    }
}
