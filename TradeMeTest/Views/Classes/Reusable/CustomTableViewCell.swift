import UIKit

internal class CustomTableViewCell<ContentView>: UITableViewCell, CustomCellProtocol where ContentView: UIView {
    // MARK: properties
    internal lazy var innerContentView: ContentView = {
        type(of: self).createContentView()
    }()
    
    // MARK: init/deinit
    internal override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCustomView()
        setupConstraints()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
