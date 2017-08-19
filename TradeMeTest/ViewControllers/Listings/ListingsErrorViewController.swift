import UIKit

internal final class ListingsErrorViewController: UIViewController {
    // MARK: init/deinit
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
