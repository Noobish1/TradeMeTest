import UIKit
import SnapKit
import RxSwift

internal enum ListingsContainerViewControllerState {
    case initial(ListingsInitialViewController)
    case loading(ListingsLoadingViewController)
    case loaded(ListingsViewController)
    case failedToLoad(ListingsErrorViewController)
    case noResults(ListingsNoResultsViewController)
    
    fileprivate var viewController: UIViewController {
        switch self {
            case .initial(let vc): return vc
            case .loading(let vc): return vc
            case .loaded(let vc): return vc
            case .failedToLoad(let vc): return vc
            case .noResults(let vc): return vc
        }
    }
}

internal final class ListingsContainerViewController: UIViewController, ContainerViewControllerProtocol {
    // MARK: properties
    private var state: ListingsContainerViewControllerState
    private let containerView = UIView()
    private let disposeBag = DisposeBag()
    
    // MARK: init/deinit
    internal init() {
        self.state = .initial(ListingsInitialViewController())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        self.view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupInitialViewController(state.viewController, containerView: containerView)
    }
    
    // MARK: update
    internal func update(with searchParams: SearchParams) {
        transition(to: .loading(ListingsLoadingViewController()))
        
        APIClient.shared.search(params: searchParams)
            .map { $0.listings.map(ListingViewModel.init) }
            .subscribe(onSuccess: { [weak self] listings in
                if listings.isEmpty {
                    self?.transition(to: .noResults(ListingsNoResultsViewController()))
                } else {
                    self?.transition(to: .loaded(ListingsViewController(listings: listings)))
                }
            }, onError: { [weak self] _ in
                self?.transition(to: .failedToLoad(ListingsErrorViewController()))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: transition
    private func transition(to newState: ListingsContainerViewControllerState) {
        let fromVC = self.state.viewController
        let toVC = newState.viewController
        
        transitionFromViewController(fromVC, toViewController: toVC, containerView: containerView)
        
        self.state = newState
    }
}
