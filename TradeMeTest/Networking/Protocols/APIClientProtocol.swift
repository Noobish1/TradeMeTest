import Foundation
import Alamofire
import RxSwift
import KeyedMapper
import KeyedAPIParameters

// MARK: APIClientProtocol
internal protocol APIClientProtocol {}

// MARK: Mappable
internal extension APIClientProtocol {
    internal func rx_request<T: Mappable>(_ endpoint: APIEndpoint, params: APIParameters? = nil) -> Single<T> {
        return rx_request(endpoint, params: params, completionHandler: { response, single in
            switch response.result {
                case .failure:
                    single(.error(NetworkError(response: response)))
                case .success(let value):
                    guard let dict = value as? NSDictionary else {
                        let failureReason = "\(T.self): Type mismatch: JSON is not a dictionary"
                        let error = MapperError.custom(field: nil, message: failureReason)
                        
                        single(.error(error))
                        
                        return
                    }
                    
                    do {
                        single(.success(try T.from(dictionary: dict)))
                    } catch let error {
                        single(.error(error))
                    }
            }
        })
    }
}

// MARK: Core
fileprivate extension APIClientProtocol {
    fileprivate func rx_request<T>(_ endpoint: APIEndpoint, params: APIParameters?,
                                   completionHandler: @escaping (DataResponse<Any>, ((SingleEvent<T>) -> Void)) -> Void) -> Single<T> {
        return Single<T>.create { single -> Disposable in
            let request = RequestBuilder.buildRequest(for: endpoint, params: params)
            let requestReference = request.validate().responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    guard let httpResponse = response.response else {
                        fatalError("We did not receive a HTTPURLResponse from request \(request)")
                    }
                    
                    guard httpResponse.statusCode != 204 else {
                        completionHandler(response.withResult(result: .success(())), single)
                        
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        completionHandler(response.withResult(result: .success(json)), single)
                    } catch let error {
                        completionHandler(response.withResult(result: .failure(error)), single)
                    }
                case .failure(let error):
                    completionHandler(response.withResult(result: .failure(error)), single)
                }
            })
            
            requestReference.resume()
            
            return Disposables.create {
                requestReference.cancel()
            }
        }
    }
}
