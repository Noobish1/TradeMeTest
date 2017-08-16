import Foundation
import UIKit

internal final class SimpleViewModelDataSource<Cell: CustomViewModelCell>: NSObject, UITableViewDataSource where Cell: UITableViewCell {
    // MARK: properties
    private var viewModels: [Cell.ViewModel] = []
    
    // MARK: init/deinit
    internal init(viewModels: [Cell.ViewModel]) {
        self.viewModels = viewModels
    }
    
    // MARK: update
    internal func update(with viewModels: [Cell.ViewModel]) {
        self.viewModels = viewModels
    }
    
    // MARK: UITableViewDataSource
    // These can't be in an extension otherwise we get compiler errors
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueAndUpdateReusableCell(ofType: Cell.self, with: viewModels[indexPath.row])
    }
}
