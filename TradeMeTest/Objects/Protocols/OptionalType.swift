import Foundation

// MARK: OptionalType
internal protocol OptionalType {
    associatedtype TypeOfOptional
    
    var optionalValue: TypeOfOptional? { get }
}

// MARK: Optional extension
extension Optional: OptionalType {
    public typealias TypeOfOptional = Wrapped
    
    public var optionalValue: TypeOfOptional? {
        return self
    }
}
