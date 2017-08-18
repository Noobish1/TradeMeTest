import Foundation

internal protocol CustomViewModelCell: CustomCellProtocol {
    associatedtype ViewModel
    
    init(viewModel: ViewModel)
    func update(with viewModel: ViewModel)
}
