import UIKit

internal extension UIImage {
    internal convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
    
    internal convenience init?(color: UIColor) {
        self.init(color: color, size: CGSize(width: 1, height: 1))
    }
}
