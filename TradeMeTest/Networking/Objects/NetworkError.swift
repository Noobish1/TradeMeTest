import Foundation
import Alamofire

internal enum NetworkError: Error {
    case noInternet
    case connection(statusCode: Int)
    
    internal init(response: DataResponse<Any>) {
        if let statusCode = response.response?.statusCode {
            self = .connection(statusCode: statusCode)
        } else {
            self = .noInternet
        }
    }
}
