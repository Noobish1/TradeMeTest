import UIKit
import Then

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = UINavigationController(rootViewController: RootViewController())
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}
