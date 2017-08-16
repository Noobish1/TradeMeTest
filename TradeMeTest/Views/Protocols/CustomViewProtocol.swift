import UIKit
import SnapKit

internal protocol CustomViewProtocol: class {
    associatedtype ContentView: UIView
    
    var innerContentView: ContentView { get }
    
    static func createContentView() -> ContentView
}

// MARK: ContentView: UIView
internal extension CustomViewProtocol where ContentView: UIView {
    internal static func createContentView() -> ContentView {
        return ContentView(frame: .zero)
    }
}

// MARK: ContentView: NibCreatable
internal extension CustomViewProtocol where ContentView: NibCreatable {
    internal static func createContentView() -> ContentView {
        return ContentView.createFromNib()
    }
}

// MARK: Self: UIView
internal extension CustomViewProtocol where Self: UIView {
    internal func setupCustomView() {
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(innerContentView)
    }
    
    internal func setupConstraints() {
        innerContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
