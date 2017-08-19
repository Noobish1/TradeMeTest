import UIKit

internal class NibBackedCollectionViewCell<ContentView>: UICollectionViewCell, CustomCellProtocol where ContentView: UIView, ContentView: NibCreatable {
    // MARK: properties
    internal lazy var innerContentView: ContentView = {
        type(of: self).createContentView()
    }()
    
    // MARK: init/deinit
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCustomView()
        setupConstraints()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
