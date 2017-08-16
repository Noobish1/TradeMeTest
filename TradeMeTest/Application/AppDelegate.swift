import UIKit
import Then

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            let rootVC = CategoryViewController(title: NSLocalizedString("Categories", comment: ""), viewModels: [])
            
            $0.rootViewController = UINavigationController(rootViewController: rootVC)
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}
