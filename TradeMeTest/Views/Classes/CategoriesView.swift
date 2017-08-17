import Foundation
import UIKit
import RxSwift

internal enum CategoriesViewState {
    case loading
    case loaded(CategoryViewController)
    case failedToLoad
}

internal enum CategoriesViewPosition {
    case open
    case collapsed
    
    fileprivate static var handHoldHeight: CGFloat {
        return 20
    }
    
    fileprivate static var openVCHeight: CGFloat {
        return 44 * 7
    }
    
    internal var height: CGFloat {
        switch self {
            case .open: return type(of: self).handHoldHeight + type(of: self).openVCHeight
            case .collapsed: return type(of: self).handHoldHeight + 44
        }
    }
}

internal final class CategoriesView: UIView {
    // MARK: properties
    private var state: CategoriesViewState
    private let categoriesButton: CategoriesButton
    private let categoriesNavBar = UINavigationBar().then {
        let navItem = UINavigationItem(title: NSLocalizedString("Categories", comment: ""))
        
        $0.setItems([navItem], animated: false)
    }
    private let viewControllerContainerView = UIView()
    private let initialFetch = Singular()
    private let disposeBag = DisposeBag()
    private let onDone: (CategoryViewModel) -> Completable
    private let onTap: () -> Void
    private weak var parentVC: UIViewController?

    // MARK: init/deinit
    internal init(state: CategoriesViewState = .loading, parentVC: UIViewController, onTap: @escaping () -> Void, onDone: @escaping (CategoryViewModel) -> Completable) {
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
                        let categoryVC = CategoryViewController(viewModel: categoryVM, onDone: strongSelf.onDone)
                        
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
    
    internal func updateButtonUserInteractionEnabled(to value: Bool) {
        categoriesButton.isUserInteractionEnabled = value
    }
    
    // MARK: setup
    private func setupCategoryViewController(_ viewController: CategoryViewController) {
        guard let parentVC = self.parentVC else {
            fatalError("CategoriesView does not have a parentVC")
        }
        
        let navVC = UINavigationController(rootViewController: viewController)
        
        viewControllerContainerView.addSubview(navVC.view)
        
        parentVC.addChildViewController(navVC)
        
        navVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navVC.didMove(toParentViewController: parentVC)
    }
    
    private func setupViews() {
        let categoryHandholdContainerView = UIView()
        let categoryHandholdView = UIView().then {
            $0.backgroundColor = .darkGray
        }
        
        categoryHandholdContainerView.addSubview(categoryHandholdView)
        
        categoryHandholdView.snp.makeConstraints { make in
            make.width.equalTo(CategoriesViewPosition.handHoldHeight)
            make.height.equalTo(4)
            make.center.equalToSuperview()
        }
        
        self.addSubview(categoryHandholdContainerView)
        
        categoryHandholdContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CategoriesViewPosition.handHoldHeight)
        }
        
        setupViewControllerContainerView(below: categoryHandholdContainerView)
        setupCategoriesNavBar(below: categoryHandholdContainerView)
        setupCategoriesButton()
    }
    
    private func setupCategoriesButton() {
        self.addSubview(categoriesButton)
        
        categoriesButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCategoriesNavBar(below view: UIView) {
        self.addSubview(categoriesNavBar)
        
        categoriesNavBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    private func setupViewControllerContainerView(below view: UIView) {
        self.addSubview(viewControllerContainerView)
        
        viewControllerContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CategoriesViewPosition.openVCHeight)
        }
    }
}
