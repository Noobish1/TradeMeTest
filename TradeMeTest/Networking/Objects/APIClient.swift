import Foundation
import RxSwift

internal final class APIClient: APIClientProtocol {
    // MARK: properties
    internal static var shared = APIClient()
    
    // MARK: API calls
    internal func rootCategories() -> Single<Category> {
        return rx_request(.rootCategories)
    }
    
    internal func category(_ category: Int) -> Single<Category> {
        return rx_request(.category(category))
    }
    
    internal func search(params: SearchParams) -> Single<SearchResults> {
        return rx_request(.search, params: params)
    }
}
