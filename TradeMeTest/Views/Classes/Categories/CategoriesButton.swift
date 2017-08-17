import Foundation
import UIKit
import SnapKit

// MARK: CategoriesViewState
fileprivate extension CategoriesViewState {
    fileprivate var backgroundColor: UIColor {
        switch self {
            case .loading, .failedToLoad: return .white
            case .loaded: return .clear
        }
    }
    
    fileprivate var title: String {
        switch self {
            case .loading: return "Loading Categories..."
            case .loaded: return ""
            case .failedToLoad: return "Failed to Load Categories, tap to try again"
        }
    }
    
    fileprivate var userInteractionEnabled: Bool {
        switch self {
            case .loading: return false
            case .loaded, .failedToLoad: return true
        }
    }
    
    fileprivate var activityIndictorZeroWidthPriority: UILayoutPriority {
        switch self {
            case .loading: return UILayoutPriorityDefaultLow
            case .loaded, .failedToLoad: return UILayoutPriorityRequired - 1
        }
    }
    
    fileprivate var animateActivityIndicator: Bool {
        switch self {
            case .loading: return true
            case .loaded, .failedToLoad: return false
        }
    }
}

// MARK: CategoriesButton
internal final class CategoriesButton: UIControl {
    // MARK: properties
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let textLabel: UILabel
    private var activityIndicatorWidthConstraint: Constraint!
    
    // MARK: init/deinit
    internal init(state: CategoriesViewState) {
        self.textLabel = UILabel().then {
            $0.text = state.title
        }
        
        super.init(frame: .zero)
        
        setupViews(for: state)
        transition(to: state)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews(for state: CategoriesViewState) {
        let containerView = UIView()
        
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        containerView.addSubview(activityIndicator)
        
        activityIndicator.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30).priority(UILayoutPriorityDefaultHigh)
            activityIndicatorWidthConstraint = make.width.equalTo(0).priority(state.activityIndictorZeroWidthPriority).constraint
        }
        
        containerView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(activityIndicator.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    // MARK: transition
    internal func transition(to state: CategoriesViewState) {
        self.backgroundColor = state.backgroundColor
        self.isUserInteractionEnabled = state.userInteractionEnabled
        
        textLabel.text = state.title
        
        activityIndicatorWidthConstraint.update(priority: state.activityIndictorZeroWidthPriority)
        
        if state.animateActivityIndicator {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
    }
}
