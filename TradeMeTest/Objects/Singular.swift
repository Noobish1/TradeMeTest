import Foundation

internal final class Singular {
    private var isDone = false
    
    internal init() {}
    
    internal func performOnce(operation: () -> Void) {
        guard !isDone else { return }
        isDone = true
        
        operation()
    }
}
