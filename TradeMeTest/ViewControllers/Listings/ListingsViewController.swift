import UIKit
import Then
import SnapKit

internal final class ListingsViewController: UIViewController {
    // MARK: properties
    private lazy var collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(ListingCollectionViewCell.self, forCellWithReuseIdentifier: ListingCollectionViewCell.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .white
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
    
    // MARK: setup
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let layout = collectionViewLayout(for: self.view.frame.size)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    // MARK: rotation
    internal override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let topIndexPath = collectionView.indexPathsForVisibleItems.first
        
        coordinator.animate(alongsideTransition: { _ in
            let layout = self.collectionViewLayout(for: size)
            self.collectionView.setCollectionViewLayout(layout, animated: true)
            
            if let topIndexPath = topIndexPath {
                self.collectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
            }
        })
    }
    
    // MARK: layout logic
    private func collectionViewLayout(for size: CGSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout().then {
            $0.minimumInteritemSpacing = 2
            $0.minimumLineSpacing = 2
        }
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            layout.scrollDirection = size.width > size.height ? .horizontal : .vertical
        }
        
        return layout
    }
}

extension ListingsViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("collectionViewLayout is not a UICollectionViewFlow")
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = floor((self.view.frame.width - (flowLayout.minimumInteritemSpacing * 2))/3.0)
            
            return CGSize(width: width, height: width)
        } else {
            if self.view.frame.width > self.view.frame.height {
                // landscape
                return CGSize(width: 250, height: self.view.frame.height)
            } else {
                // portrait
                return CGSize(width: self.view.frame.width, height: 250)
            }
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
