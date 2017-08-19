import UIKit
import RxSwift

internal final class NoSubCategoriesViewController: UIViewController {
    // MARK: properties
    private let onDone: (CategoryViewModel) -> Completable
    private let viewModel: CategoryViewModel
    
    // MARK: init/deinit
    internal init(viewModel: CategoryViewModel, onDone: @escaping (CategoryViewModel) -> Completable) {
        self.viewModel = viewModel
        self.onDone = onDone
        
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        
        self.title = title
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    // MARK: Interface actions
    @objc
    private func doneButtonPressed() {
        _ = onDone(viewModel).subscribe()
    }
}
