import UIKit

internal extension UIView {
    internal func applyDefaultBorder() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
}
