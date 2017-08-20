import UIKit
import Then
import SnapKit

// MARK: CategoryTableViewCellContentView
internal final class CategoryTableViewCellContentView: UIView {
    // MARK: properties
    fileprivate let nameLabel = UILabel()
    
    // MARK: init/deinit
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNameLabel()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupNameLabel() {
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: CategoryTableViewCell
internal final class CategoryTableViewCell: CodeBackedTableViewCell<CategoryTableViewCellContentView> {
    // MARK: update
    internal func update(with viewModel: CategoryViewModel) {
        self.accessoryType = viewModel.accessoryType
        
        self.innerContentView.nameLabel.text = viewModel.name
    }
}
