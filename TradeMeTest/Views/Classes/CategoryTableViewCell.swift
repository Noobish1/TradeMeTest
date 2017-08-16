import Foundation
import UIKit
import Then
import SnapKit

internal final class CategoryTableViewCellContentView: UIView {
    // MARK: properties
    fileprivate let nameLabel: UILabel = UILabel().then {
        $0.backgroundColor = .magenta
    }
    
    // MARK: init/deinit
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal final class CategoryTableViewCell: CustomViewModelTableViewCell<CategoryTableViewCellContentView, CategoryViewModel> {
    internal required init(viewModel: CategoryViewModel) {
        super.init(viewModel: viewModel)
        
        update(with: viewModel)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func update(with viewModel: CategoryViewModel) {
        self.innerContentView.nameLabel.text = viewModel.name
    }
}
