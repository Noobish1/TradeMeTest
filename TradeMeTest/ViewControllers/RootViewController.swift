import UIKit
import SnapKit
import RxSwift

internal final class RootViewController: UIViewController {
    // MARK: properties
    private var viewModels: [CategoryViewModel] = []
    private lazy var dataSource: SimpleViewModelDataSource<CategoryTableViewCell> = {
        SimpleViewModelDataSource<CategoryTableViewCell>(viewModels: self.viewModels)
    }()
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped).then {
        $0.dataSource = self.dataSource
        $0.delegate = self
        $0.rowHeight = 44
        $0.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    private let refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(fetchRootCategories), for: .valueChanged)
    }
    private let disposeBag = DisposeBag()
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialViews()
        setupConstraints()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchRootCategories()
    }
    
    // MARK: fetch
    @objc
    private func fetchRootCategories() {
        refreshControl.beginRefreshing()
        
        APIClient.shared.rootCategories()
            .map { $0.subcategories.map(CategoryViewModel.init) }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                
                strongSelf.refreshControl.endRefreshing()
                
                switch event {
                    case .success(let categories):
                        strongSelf.dataSource.update(with: categories)
                        strongSelf.tableView.reloadData()
                    case .error:
                        // TODO: handle error
                        break
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: setup
    private func setupInitialViews() {
        self.view.addSubview(tableView)
        tableView.addSubview(refreshControl)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RootViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Remove the space at the bottom of the tableview
        return .leastNormalMagnitude
    }
}
