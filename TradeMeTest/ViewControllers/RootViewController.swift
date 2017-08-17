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
}

internal final class RootViewController: UIViewController {
    // MARK: outlets
    @IBOutlet private weak var categoriesContainerView: UIView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    // MARK: properties
    private lazy var categoryViewController: CategoryViewController = {
        let initialTitle = NSLocalizedString("Categories", comment: "")
        
        return CategoryViewController(title: initialTitle, viewModels: [], onDone: { [weak self] in
            guard let strongSelf = self else {
                return .empty()
            }
            
            return strongSelf.doneButtonPressed()
        })
    }()
    private let categoriesButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(categoriesButtonPressed), for: .touchUpInside)
    }
    private let categoriesNavBar = UINavigationBar().then {
        let navItem = UINavigationItem(title: NSLocalizedString("Categories", comment: ""))
        
        $0.setItems([navItem], animated: false)
    }
    // MARK: constants
    private final let handHoldHeight: CGFloat = 20
    private final let categoryVCHeight: CGFloat = 44 * 7
    
    // MARK: init/deinit
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryHandholdContainerView = UIView()
        let categoryHandholdView = UIView().then {
            $0.backgroundColor = .darkGray
        }
        
        categoryHandholdContainerView.addSubview(categoryHandholdView)
        
        categoryHandholdView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(4)
            make.center.equalToSuperview()
        }
        
        categoriesContainerView.addSubview(categoryHandholdContainerView)
        
        categoryHandholdContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(handHoldHeight)
        }
        
        let vcContainerView = UIView()
        
        categoriesContainerView.addSubview(vcContainerView)
        
        vcContainerView.snp.makeConstraints { make in
            make.top.equalTo(categoryHandholdContainerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(categoryVCHeight)
        }
        
        let navVC = UINavigationController(rootViewController: categoryViewController)
        
        vcContainerView.addSubview(navVC.view)
        
        navVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addChildViewController(navVC)
        navVC.didMove(toParentViewController: self)
        
        categoriesContainerView.addSubview(categoriesNavBar)
        
        categoriesNavBar.snp.makeConstraints { make in
            make.top.equalTo(categoryHandholdContainerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        categoriesContainerView.addSubview(categoriesButton)
        
        categoriesButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: interface actions
    @objc
    private func categoriesButtonPressed() {
        categoriesHeightConstraint.constant = self.categoryVCHeight + self.handHoldHeight
        
        performCategoriesAnimation(.present, completion: nil)
    }
    
    private func doneButtonPressed() -> Completable {
        return .create { [weak self] observer in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            
            strongSelf.categoriesHeightConstraint.constant = 64
            
            strongSelf.performCategoriesAnimation(.dismiss, completion: {
                observer(.completed)
            })
            
            return Disposables.create()
        }
    }
    
    // MARK: animations
    private func performCategoriesAnimation(_ animation: CategoriesAnimation, completion: (() -> Void)?) {
        UIView.animate(withDuration: animation.duration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.categoriesNavBar.alpha = animation.navBarAlpha
        }, completion: { _ in
            self.categoriesButton.isUserInteractionEnabled = animation.categoriesButtonEnabledAfter
            
            completion?()
        })
    }
}
