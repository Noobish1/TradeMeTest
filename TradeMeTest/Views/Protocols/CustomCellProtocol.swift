import UIKit

// MARK: CustomCellProtocol
internal protocol CustomCellProtocol: CustomViewProtocol {
    static var identifier: String { get }
}

// MARK: CustomCellProtocol extension
internal extension CustomCellProtocol {
    internal static var identifier: String {
        return String(describing: type(of: self))
    }
}

// MARK: CustomCellProtocol where Self: ViewWithAContentViewProtocol
extension CustomCellProtocol where Self: ViewWithAContentViewProtocol {
    internal func setupCustomView() {
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(innerContentView)
    }
}
