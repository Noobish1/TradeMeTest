import Foundation
import UIKit

internal class CustomViewModelTableViewCell<ContentView, ViewModel>: UITableViewCell, CustomViewModelCell where ContentView: UIView {
    // MARK: properties
    internal lazy var innerContentView: ContentView = {
        type(of: self).createContentView()
    }()
    private var needsToSetupConstraints = true
    
    // MARK: init/deinit
    internal required init(viewModel: ViewModel) {
        super.init(style: .default, reuseIdentifier: type(of: self).identifier)
        
        setupCustomView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: update
    internal func update(with viewModel: ViewModel) {
        
    }
    
    // MARK: constraints
    internal override func updateConstraints() {
        if needsToSetupConstraints {
            needsToSetupConstraints = false
            
            setupConstraints()
        }
        
        super.updateConstraints()
    }
}
