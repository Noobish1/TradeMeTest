import Foundation
import UIKit

internal class CustomTableViewCell<ContentView>: UITableViewCell, CustomTableViewCellProtocol where ContentView: UIView {
    // MARK: properties
    internal lazy var innerContentView: ContentView = {
        type(of: self).createContentView()
    }()
    private var needsToSetupConstraints = true
    
    // MARK: init/deinit
    internal override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCustomView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
