import Foundation

internal extension Dictionary {
    internal func byUpdating(pairs: [Key : Value]) -> Dictionary {
        var us = self
        
        pairs.forEach { key, value in
            us.updateValue(value, forKey: key)
        }
        
        return us
    }
}
