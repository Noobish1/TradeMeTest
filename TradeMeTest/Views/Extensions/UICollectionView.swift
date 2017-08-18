import UIKit

internal extension UICollectionView {
    internal func dequeueAndUpdateReusableCell<T: CustomViewModelCell>(with viewModel: T.ViewModel, for indexPath: IndexPath) -> T {
        let cell: T = dequeueCustomReusableCell(for: indexPath)
        cell.update(with: viewModel)
        
        return cell
    }
    
    internal func dequeueCustomReusableCell<T: CustomCellProtocol>(for indexPath: IndexPath) -> T {
        
        print("IDENTIFIER: \(T.identifier)")
        
        let rawCell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        
        guard let typedCell = rawCell as? T else {
            fatalError("dequeue returned the wrong type")
        }
        
        return typedCell
    }
}
