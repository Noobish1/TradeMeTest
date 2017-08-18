import Foundation

internal protocol OptionalType {
    associatedtype TypeOfOptional
    
    var optionalValue: TypeOfOptional? { get }
}

extension Optional: OptionalType {
    public typealias TypeOfOptional = Wrapped
    
    public var optionalValue: TypeOfOptional? {
        return self
    }
}
