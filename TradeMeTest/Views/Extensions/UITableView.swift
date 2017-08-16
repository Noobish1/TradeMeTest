import Foundation
import UIKit

internal extension UITableView {
    internal func dequeueAndUpdateReusableCell<T: CustomViewModelCell>(ofType: T.Type, with viewModel: T.ViewModel) -> T {
        let cell = dequeueCustomReusableCell(ofType: T.self) ?? T(viewModel: viewModel)
        cell.update(with: viewModel)
        
        return cell
    }
    
    internal func dequeueCustomReusableCell<T: CustomTableViewCellProtocol>(ofType: T.Type) -> T? {
        guard let rawCell = dequeueReusableCell(withIdentifier: T.identifier) else {
            return nil
        }
        
        guard let typedCell = rawCell as? T else {
            fatalError("dequeue returned the wrong type")
        }
        
        return typedCell
    }
}
