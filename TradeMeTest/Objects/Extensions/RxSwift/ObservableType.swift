import Foundation
import RxSwift

internal extension ObservableType where E: OptionalType {
    internal func nilFiltered() -> Observable<E.TypeOfOptional> {
        return Observable.create { obs in
            self.subscribe(onNext: { optional in
                if let unwrapped = optional.optionalValue {
                    obs.onNext(unwrapped)
                }
            }, onError: obs.onError, onCompleted: obs.onCompleted)
        }
    }
}
