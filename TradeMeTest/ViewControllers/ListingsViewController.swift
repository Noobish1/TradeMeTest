import UIKit
import Then
import SnapKit

internal final class ListingsViewController: UIViewController {
    // MARK: properties
    private lazy var collectionView: UICollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(ListingCollectionViewCell.self, forCellWithReuseIdentifier: ListingCollectionViewCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    fileprivate let listings: [ListingViewModel]
    
    // MARK: init/deinit
    internal init(listings: [ListingViewModel]) {
        self.listings = listings
        
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: rotation
    internal override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let scrollDirection: UICollectionViewScrollDirection = size.width > size.height ? .horizontal : .vertical
        
        coordinator.animate(alongsideTransition: { _ in
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = scrollDirection
            
            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }, completion: nil)
    }
}

extension ListingsViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.view.frame.width > self.view.frame.size.height {
            // landscape
            return CGSize(width: 250, height: self.view.frame.size.height)
        } else {
            // portrait
            return CGSize(width: self.view.frame.width, height: 250)
        }
    }
}

extension ListingsViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCollectionViewCell.identifier, for: indexPath)
        
        guard let typedCell = rawCell as? ListingCollectionViewCell else {
            fatalError("dequeue returned the wrong type")
        }
        
        typedCell.update(with: listings[indexPath.row])
        
        return typedCell
    }
}
