import UIKit
import Then
import SnapKit

// MARK: CategoryTableViewCellContentView
internal final class CategoryTableViewCellContentView: UIView {
    // MARK: properties
    fileprivate let nameLabel: UILabel = UILabel()
    
    // MARK: init/deinit
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: CategoryTableViewCell
internal final class CategoryTableViewCell: CustomViewModelTableViewCell<CategoryTableViewCellContentView, CategoryViewModel> {
    // MARK: init/deinit
    internal required init(viewModel: CategoryViewModel) {
        super.init(viewModel: viewModel)
        
        update(with: viewModel)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: update
    internal override func update(with viewModel: CategoryViewModel) {
        self.accessoryType = viewModel.accessoryType
        
        self.innerContentView.nameLabel.text = viewModel.name
    }
}
