import UIKit

internal final class SimpleCollectionViewModelDataSource<Cell: CustomViewModelCell>: NSObject, UICollectionViewDataSource where Cell: UICollectionViewCell {
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
    
    // MARK: retrieval
    internal func viewModel(at indexPath: IndexPath) -> Cell.ViewModel {
        return viewModels[indexPath.row]
    }
    
    // MARK: UICollectionViewDataSource
    // These can't be in an extension otherwise we get compiler errors
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueAndUpdateReusableCell(with: viewModels[indexPath.row], for: indexPath)
        
        return cell
    }
}
