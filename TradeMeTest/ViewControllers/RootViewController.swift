import UIKit
import SnapKit
import RxSwift

fileprivate enum CategoriesAnimation {
    case present
    case dismiss
    
    fileprivate var duration: TimeInterval {
        return 0.35
    }
    
    fileprivate var navBarAlpha: CGFloat {
        switch self {
            case .present: return 0
            case .dismiss: return 1
        }
    }
    
    fileprivate var categoriesButtonEnabledAfter: Bool {
        switch self {
            case .present: return false
            case .dismiss: return true
        }
    }
    
    fileprivate var categoriesHeightConstant: CGFloat {
        switch self {
            case .present: return CategoriesViewPosition.open.height
            case .dismiss: return CategoriesViewPosition.collapsed.height
        }
    }
}

internal final class RootViewController: UIViewController {
    // MARK: outlets
    @IBOutlet private weak var categoriesContainerView: UIView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    // MARK: properties
    private lazy var categoriesView: CategoriesView = {
        CategoriesView(parentVC: self, onTap: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.categoriesButtonPressed()
        }, onDone: { [weak self] viewModel -> Completable in
            guard let strongSelf = self else {
                return .empty()
            }
            
            print("\(viewModel.name) selected!")
            
            return strongSelf.doneButtonPressed()
        })
    }()
    
    // MARK: init/deinit
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupCategoriesView() {
        categoriesContainerView.addSubview(categoriesView)
        
        categoriesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoriesView()
    }
    
    // MARK: interface actions
    private func categoriesButtonPressed() {
        performCategoriesAnimation(.present, completion: nil)
    }
    
    private func doneButtonPressed() -> Completable {
        return .create { [weak self] observer in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            
            strongSelf.performCategoriesAnimation(.dismiss, completion: {
                observer(.completed)
            })
            
            return Disposables.create()
        }
    }
    
    // MARK: animations
    private func performCategoriesAnimation(_ animation: CategoriesAnimation, completion: (() -> Void)?) {
        categoriesHeightConstraint.constant = animation.categoriesHeightConstant
        
        UIView.animate(withDuration: animation.duration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.categoriesView.updateNavBarAlpha(to: animation.navBarAlpha)
        }, completion: { _ in
            self.categoriesView.updateButtonUserInteractionEnabled(to: animation.categoriesButtonEnabledAfter)
            
            completion?()
        })
    }
}
