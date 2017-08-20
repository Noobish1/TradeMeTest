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
    private func setupContainerView() -> UIView {
        let containerView = UIView()
        
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return containerView
    }
    
    private func setupActivityIndicator(in containerView: UIView, for state: CategoriesViewState) {
        containerView.addSubview(activityIndicator)
        
        activityIndicator.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30).priority(UILayoutPriorityDefaultHigh)
            activityIndicatorWidthConstraint = make.width.equalTo(0).priority(state.activityIndictorZeroWidthPriority).constraint
        }
    }
    
    private func setupTextLabel(in containerView: UIView) {
        containerView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(activityIndicator.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func setupViews(for state: CategoriesViewState) {
        let containerView = setupContainerView()
        setupActivityIndicator(in: containerView, for: state)
        setupTextLabel(in: containerView)
    }
    
    // MARK: transition
    internal func transition(to state: CategoriesViewState) {
        self.backgroundColor = state.backgroundColor
        
        textLabel.text = state.title
        
        activityIndicatorWidthConstraint.update(priority: state.activityIndictorZeroWidthPriority)
        
        if state.animateActivityIndicator {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
    }
}
