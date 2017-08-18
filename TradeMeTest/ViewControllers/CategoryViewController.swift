import UIKit
import SnapKit
import RxSwift

internal final class CategoryViewController: UIViewController {
    // MARK: properties
    fileprivate let dataSource: SimpleTableViewModelDataSource<CategoryTableViewCell>
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped).then {
        $0.dataSource = self.dataSource
        $0.delegate = self
        $0.rowHeight = 44
        $0.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    private let disposeBag = DisposeBag()
    private let needsInitialLoad: Bool
    fileprivate let onDone: (CategoryViewModel) -> Completable
    fileprivate let viewModel: CategoryViewModel
    
    // MARK: init/deinit
    internal init(viewModel: CategoryViewModel, onDone: @escaping (CategoryViewModel) -> Completable) {
        self.viewModel = viewModel
        self.onDone = onDone
        self.needsInitialLoad = viewModel.subcategoires.isEmpty
        self.dataSource = SimpleTableViewModelDataSource<CategoryTableViewCell>(viewModels: viewModel.subcategoires)
            
        super.init(nibName: nil, bundle: nil)
        
        self.title = viewModel.name
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
    
    // MARK: setup
    private func setupInitialViews() {
        self.view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func doneButtonPressed() {
        _ = onDone(viewModel).subscribe()
    }
}

extension CategoryViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedViewModel = dataSource.viewModel(at: indexPath)
        
        if selectedViewModel.hasSubcategories {
            let rootVC = CategoryViewController(viewModel: selectedViewModel, onDone: onDone)
            
            self.navigationController?.pushViewController(rootVC, animated: true)
        } else {
            _ = onDone(selectedViewModel).subscribe(onCompleted: { [weak self] in
                guard let strongSelf = self else { return }
                
                let noSubCategoriesVC = NoSubCategoriesViewController(viewModel: selectedViewModel, onDone: strongSelf.onDone)
                
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
