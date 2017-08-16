import UIKit
import SnapKit

internal final class RootViewController: UIViewController {
    // MARK: outlets
    @IBOutlet private weak var categoriesContainerView: UIView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    // MARK: properties
    private lazy var categoryViewController: CategoryViewController = {
        let initialTitle = NSLocalizedString("Categories", comment: "")
        
        return CategoryViewController(title: initialTitle, viewModels: [], onDone: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.doneButtonPressed()
        })
    }()
    private let categoriesButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(categoriesButtonPressed), for: .touchUpInside)
    }
    
    // MARK: init/deinit
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let handHoldHeight: CGFloat = 20
    private let categoryVCHeight: CGFloat = 44 * 7
    
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
        
        categoriesContainerView.addSubview(categoriesButton)
        
        categoriesButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: interface actions
    @objc
    private func categoriesButtonPressed() {
        self.categoriesHeightConstraint.constant = self.categoryVCHeight + self.handHoldHeight
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.categoriesButton.isUserInteractionEnabled = false
        })
    }
    
    private func doneButtonPressed() {
        self.categoriesHeightConstraint.constant = 64
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.categoriesButton.isUserInteractionEnabled = true
        })
    }
}
