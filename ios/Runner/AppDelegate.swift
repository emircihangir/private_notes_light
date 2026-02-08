import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var privacyBlurView: UIVisualEffectView?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // 2. Event: App is about to move to background (User swiped up)
        override func applicationWillResignActive(_ application: UIApplication) {
            // Create a blur effect
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            privacyBlurView = UIVisualEffectView(effect: blurEffect)
            
            if let window = self.window {
                // Make the blur fit the whole screen
                privacyBlurView?.frame = window.frame
                // Add it on top of everything
                window.addSubview(privacyBlurView!)
            }
            
            super.applicationWillResignActive(application)
        }

        // 3. Event: App came back to foreground
        override func applicationDidBecomeActive(_ application: UIApplication) {
            // Remove the blur view so the user can see their notes
            privacyBlurView?.removeFromSuperview()
            privacyBlurView = nil
            
            super.applicationDidBecomeActive(application)
        }
}
