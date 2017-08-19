import UIKit
import SnapKit
import RxSwift

internal final class CategoryViewController: UIViewController {
    // MARK: properties
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped).then {
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 44
        $0.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    private let disposeBag = DisposeBag()
    private let needsInitialLoad: Bool
    fileprivate let categories: [CategoryViewModel]
    fileprivate let onDone: (CategoryViewModel) -> Completable
    fileprivate let category: CategoryViewModel
    
    // MARK: init/deinit
    internal init(viewModel: CategoryViewModel, onDone: @escaping (CategoryViewModel) -> Completable) {
        self.category = viewModel
        self.onDone = onDone
        self.needsInitialLoad = viewModel.subcategoires.isEmpty
        self.categories = viewModel.subcategoires
            
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
        _ = onDone(category).subscribe()
    }
}

extension CategoryViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = categories[indexPath.row]
        
        guard let rawCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) else {
            fatalError("Could not dequeue a CategoryTableViewCell")
        }
        
        guard let typedCell = rawCell as? CategoryTableViewCell else {
            fatalError("dequeue returned the wrong type")
        }
        
        typedCell.update(with: viewModel)
        
        return typedCell
    }
}

extension CategoryViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedViewModel = categories[indexPath.row]
        
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
