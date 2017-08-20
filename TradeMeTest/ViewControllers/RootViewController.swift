import UIKit
import SnapKit
import RxSwift
import KeyboardObserver
import Then

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

internal final class RootViewController: UIViewController, ContainerViewControllerProtocol {
    // MARK: outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var categoriesContainerView: UIView!
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var statusBarView: UIView!
    @IBOutlet private weak var leftPadView: UIView!
    // MARK: properties
    private var categoriesTopToTopConstraint: Constraint!
    private lazy var categoriesView: CategoriesView = {
        CategoriesView(parentVC: self, onTap: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.categoriesButtonPressed()
        }, onDone: { [weak self] in
            guard let strongSelf = self else {
                return .empty()
            }
            
            return strongSelf.doneButtonPressed()
        })
    }()
    private let searchView = SearchView()
    private let listingsContainerViewController = ListingsContainerViewController()
    private let keyboard = KeyboardObserver().then {
        $0.isEnabled = false
    }
    private let disposeBag = DisposeBag()
    
    // MARK: init/deinit
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupSearchView() {
        searchContainerView.addSubview(searchView)
        searchContainerView.layer.borderColor = UIColor.black.cgColor
        searchContainerView.layer.borderWidth = 2
        
        searchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCategoriesView() {
        if UIDevice.current.userInterfaceIdiom != .pad {
            categoriesContainerView.snp.makeConstraints { make in
                categoriesTopToTopConstraint = make.top.equalTo(self.topLayoutGuide.snp.bottom).constraint
            }
            
            categoriesTopToTopConstraint.deactivate()
        }
        
        categoriesContainerView.addSubview(categoriesView)
        
        categoriesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupKeyboardObserver() {
        keyboard.observe { [weak self] event in
            guard let strongSelf = self else { return }
            
            strongSelf.handleKeyboardEvent(event)
        }
    }
    
    private func setupObservers() {
        Observable
            .combineLatest(searchView.observable, categoriesView.observable.map { $0?.number })
            .map(SearchParams.init)
            .nilFiltered()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] params in
                print("search with params: \(params)")
                
                self?.listingsContainerViewController.update(with: params)
            }).disposed(by: disposeBag)
    }
    
    private func setupListingsView() {
        setupInitialViewController(listingsContainerViewController, containerView: containerView)
    }
    
    private func setupContainerView() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 2
    }
    
    private func setupStatusBarView() {
        statusBarView.layer.borderColor = UIColor.black.cgColor
        statusBarView.layer.borderWidth = 2
    }
    
    private func setupLeftPadViewIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            leftPadView.layer.borderColor = UIColor.black.cgColor
            leftPadView.layer.borderWidth = 2
        }
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftPadViewIfNeeded()
        setupStatusBarView()
        setupContainerView()
        setupSearchView()
        setupCategoriesView()
        setupListingsView()
        setupKeyboardObserver()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboard.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboard.isEnabled = false
    }
    
    // MARK: keyboard handling
    private func handleKeyboardEvent(_ event: KeyboardEvent) {
        switch event.type {
            case .willChangeFrame:
                // We need to always start with the original search frame (ignoring the bottom constraint)
                var originalSearchFrame = self.searchContainerView.frame
                originalSearchFrame.origin.y += self.containerBottomConstraint.constant
                
                let searchFrame = self.view.convert(originalSearchFrame, to: nil)
                let intersectFrame = searchFrame.intersection(event.keyboardFrameEnd)
                let distanceBetweenSearchViewAndBottom = self.view.frame.maxY - originalSearchFrame.maxY
                let bottomConstant = (intersectFrame.isNull || intersectFrame.height == 0) ? 0 : (event.keyboardFrameEnd.height - distanceBetweenSearchViewAndBottom)
                
                self.containerBottomConstraint.constant = bottomConstant
                
                UIView.animate(withDuration: event.duration, delay: 0, options: [event.options], animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
                break
            case .willShow, .willHide, .didShow, .didHide, .didChangeFrame:
                break
        }
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            categoriesHeightConstraint.constant = animation.categoriesHeightConstant
        } else {
            if animation == .present {
                categoriesTopToTopConstraint.activate()
            } else {
                categoriesTopToTopConstraint.deactivate()
            }
        }
        
        UIView.animate(withDuration: animation.duration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.categoriesView.updateNavBarAlpha(to: animation.navBarAlpha)
        }, completion: { _ in
            self.categoriesView.updateTopContainerUserInteractionEnabled(to: animation.categoriesButtonEnabledAfter)
            
            completion?()
        })
    }
}
