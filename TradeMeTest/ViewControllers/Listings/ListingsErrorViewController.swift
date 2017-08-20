import UIKit

internal final class ListingsErrorViewController: UIViewController {
    // MARK: properties
    private let onTap: () -> Void
    
    // MARK: init/deinit
    internal init(onTap: @escaping () -> Void) {
        self.onTap = onTap
        
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Interface actions
    @IBAction func buttonTapped() {
        onTap()
    }
}
