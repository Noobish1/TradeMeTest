import UIKit
import SnapKit
import RxSwift

internal final class CategoryViewController: UIViewController {
    // MARK: properties
    fileprivate let dataSource: SimpleViewModelDataSource<CategoryTableViewCell>
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
    private let needsInitialLoad: Bool
    // TODO: pass back a CategoryViewModel
    fileprivate let onDone: () -> Completable
    
    // MARK: init/deinit
    internal init(title: String, viewModels: [CategoryViewModel], onDone: @escaping () -> Completable) {
        self.onDone = onDone
        self.needsInitialLoad = viewModels.isEmpty
        self.dataSource = SimpleViewModelDataSource<CategoryTableViewCell>(viewModels: viewModels)
            
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialViews()
        setupConstraints()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if needsInitialLoad {
            fetchRootCategories()
        }
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func doneButtonPressed() {
        _ = onDone().subscribe()
    }
}

extension CategoryViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = dataSource.viewModel(at: indexPath)
        
        if viewModel.hasSubcategories {
            let rootVC = CategoryViewController(title: viewModel.name, viewModels: viewModel.subcategoires, onDone: onDone)
            
            self.navigationController?.pushViewController(rootVC, animated: true)
        } else {
            _ = onDone().subscribe(onCompleted: { [weak self] in
                guard let strongSelf = self else { return }
                
                let noSubCategoriesVC = NoSubCategoriesViewController(title: viewModel.name, onDone: strongSelf.onDone)
                
                strongSelf.navigationController?.pushViewController(noSubCategoriesVC, animated: false)
            })
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Remove the space at the top of the tableview
        return .leastNormalMagnitude
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Remove the space at the bottom of the tableview
        return .leastNormalMagnitude
    }
}
