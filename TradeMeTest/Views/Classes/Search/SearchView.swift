import UIKit
import SnapKit
import RxSwift

// MARK: SearchView
internal final class SearchView: UIView {
    // MARK: properties
    private lazy var searchField = UITextField().then {
        $0.borderStyle = .line
        $0.returnKeyType = .search
        $0.enablesReturnKeyAutomatically = true
        $0.autocorrectionType = .no
        $0.delegate = self
        $0.placeholder = NSLocalizedString("Search", comment: "")
        $0.font = .systemFont(ofSize: 23)
        $0.textAlignment = .center
    }
    fileprivate let behaviorSubject = BehaviorSubject<String?>(value: nil)
    internal var observable: Observable<String?> {
        return behaviorSubject.asObservable()
    }
    
    // MARK: init/deinit
    internal init() {
        super.init(frame: .zero)
        
        self.addSubview(searchField)
        
        searchField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        behaviorSubject.onNext(textField.text)
        
        return true
    }
}
