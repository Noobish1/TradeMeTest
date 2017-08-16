import Foundation

public protocol NibCreatable {
    static func createFromNib() -> Self
}

public extension NibCreatable {
    public static func createFromNib() -> Self {
        let nibName = String(describing: self)
        
        guard let objects = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil) else {
            fatalError("Could not create the nib for \(nibName).")
        }
        guard let object = objects.first else {
            fatalError("Nib objects array is empty.")
        }
        guard let selfObject = object as? Self else {
            fatalError("Could not cast object as \(type(of: self)).")
        }
        
        return selfObject
    }
}
