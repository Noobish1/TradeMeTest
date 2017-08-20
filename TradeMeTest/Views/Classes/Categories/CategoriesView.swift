import UIKit
import RxSwift
import SnapKit

internal enum CategoriesViewState {
    case loading
    case loaded(CategoryViewController)
    case failedToLoad
}

internal enum CategoriesViewPosition {
    case open
    case collapsed
    
    fileprivate static var handHoldWidth: CGFloat {
        return 20
    }
    
    fileprivate static var handHoldContainerHeight: CGFloat {
        return 20
    }
    
    fileprivate static var handholdHeight: CGFloat {
        return 4
    }
    
    fileprivate static var openVCHeight: CGFloat {
        return 44 * 7
    }
    
    internal var height: CGFloat {
        switch self {
            case .open: return type(of: self).handHoldWidth + type(of: self).openVCHeight
            case .collapsed: return type(of: self).handHoldWidth + 44
        }
    }
}

internal final class CategoriesView: UIView {
    // MARK: properties
    private var state: CategoriesViewState
    private let topContainerView = UIView()
    private let categoriesButton: CategoriesButton
    private let categoriesNavBar = UINavigationBar().then {
        let navItem = UINavigationItem(title: NSLocalizedString("Categories", comment: ""))
        
        $0.setItems([navItem], animated: false)
        $0.barTintColor = .white
    }
    private let viewControllerContainerView = UIView().then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
    }
    private let initialFetch = Singular()
    private let disposeBag = DisposeBag()
    private let onDone: () -> Completable
    private let onTap: () -> Void
    private weak var parentVC: UIViewController?
    private let behaviorSubject = BehaviorSubject<CategoryViewModel?>(value: nil)
    internal var observable: Observable<CategoryViewModel?> {
        return behaviorSubject.asObservable()
    }

    // MARK: init/deinit
    internal init(state: CategoriesViewState = .loading, parentVC: UIViewController, onTap: @escaping () -> Void, onDone: @escaping () -> Completable) {
        self.state = state
        self.parentVC = parentVC
        self.onTap = onTap
        self.onDone = onDone
        self.categoriesButton = CategoriesButton(state: state)
        
        super.init(frame: .zero)

        setupViews()
        
        categoriesButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Interface actions
    @objc
    private func buttonTapped() {
        switch state {
            case .loading: break
            case .loaded: onTap()
            case .failedToLoad: fetchRootCategories()
        }
    }
    
    // MARK: UIView
    internal override func didMoveToWindow() {
        guard self.window != nil else { return }
        
        initialFetch.performOnce {
            fetchRootCategories()
        }
    }
    
    // MARK: fetch
    private func fetchRootCategories() {
        transition(to: .loading)
        
        APIClient.shared.rootCategories()
            .map { CategoryViewModel(name: NSLocalizedString("Categories", comment: ""), category: $0) }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                
                switch event {
                    case .success(let categoryVM):
                        let categoryVC = CategoryViewController(viewModel: categoryVM, onDone: { viewModel in
                            strongSelf.behaviorSubject.onNext(viewModel)
                            
                            return strongSelf.onDone()
                        })
                        
                        strongSelf.transition(to: .loaded(categoryVC))
                    case .error:
                        strongSelf.transition(to: .failedToLoad)
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: transition
    private func transition(to newState: CategoriesViewState) {
        let oldState = self.state
        
        switch (oldState, newState) {
            case (.loading, .loaded(let categoryVC)), (.failedToLoad, .loaded(let categoryVC)):
                setupCategoryViewController(categoryVC)
            case (.loaded, .loading), (.loaded, .failedToLoad):
                viewControllerContainerView.subviews.forEach { $0.removeFromSuperview() }
            case (.loaded, .loaded(let newCategoryViewController)):
                viewControllerContainerView.subviews.forEach { $0.removeFromSuperview() }
                setupCategoryViewController(newCategoryViewController)
            case (.loading, .loading), (.failedToLoad, .failedToLoad),
                 (.loading, .failedToLoad), (.failedToLoad, .loading):
                break
        }
        
        categoriesButton.transition(to: newState)
        
        self.state = newState
    }
    
    // MARK: update
    internal func updateNavBarAlpha(to value: CGFloat) {
        categoriesNavBar.alpha = value
    }
    
    internal func updateTopContainerUserInteractionEnabled(to value: Bool) {
        topContainerView.isUserInteractionEnabled = value
    }
    
    // MARK: setup
    private func setupCategoryViewController(_ viewController: CategoryViewController) {
        guard let parentVC = self.parentVC else {
            fatalError("CategoriesView does not have a parentVC")
        }
        
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.navigationBar.barTintColor = .white
        navVC.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        navVC.navigationBar.shadowImage = UIImage(color: .black)
        
        viewControllerContainerView.addSubview(navVC.view)
        
        parentVC.addChildViewController(navVC)
        
        navVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navVC.didMove(toParentViewController: parentVC)
    }
    
    private func setupViews() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.addSubview(topContainerView)
        
        let innerContainerView = UIView()
        innerContainerView.clipsToBounds = true
        
        topContainerView.addSubview(innerContainerView)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            topContainerView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(64)
            }
            
            innerContainerView.snp.makeConstraints { make in
                make.width.equalTo(topContainerView.snp.height)
                make.height.equalTo(topContainerView.snp.width)
                make.center.equalToSuperview()
            }
            
            let radians = CGFloat(-90 * Double.pi / 180)
            innerContainerView.layer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        } else {
            topContainerView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(64)
            }
            
            innerContainerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        let categoryHandholdContainerView = UIView()
        let categoryHandholdView = UIView().then {
            $0.backgroundColor = .darkGray
        }
        
        categoryHandholdContainerView.addSubview(categoryHandholdView)
        
        categoryHandholdView.snp.makeConstraints { make in
            make.width.equalTo(CategoriesViewPosition.handHoldWidth)
            make.height.equalTo(CategoriesViewPosition.handholdHeight)
            make.center.equalToSuperview()
        }
        
        innerContainerView.addSubview(categoryHandholdContainerView)
        
        categoryHandholdContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CategoriesViewPosition.handHoldContainerHeight)
        }
        
        setupViewControllerContainerView(relativeTo: topContainerView)
        setupCategoriesNavBar(below: categoryHandholdContainerView, in: innerContainerView)
        setupCategoriesButton(in: innerContainerView)
    }
    
    private func setupCategoriesButton(in containerView: UIView) {
        containerView.addSubview(categoriesButton)
        
        categoriesButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCategoriesNavBar(below view: UIView, in containerView: UIView) {
        containerView.addSubview(categoriesNavBar)
        
        categoriesNavBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupViewControllerContainerView(relativeTo view: UIView) {
        self.insertSubview(viewControllerContainerView, at: 0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerContainerView.snp.makeConstraints { make in
                make.leading.equalTo(view.snp.trailing).inset(44)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(CategoriesViewPosition.openVCHeight)
            }
        } else {
            viewControllerContainerView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.bottom).inset(44)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}
