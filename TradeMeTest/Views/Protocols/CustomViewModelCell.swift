import Foundation

internal protocol CustomViewModelCell: CustomTableViewCellProtocol {
    associatedtype ViewModel
    
    init(viewModel: ViewModel)
    func update(with viewModel: ViewModel)
}
