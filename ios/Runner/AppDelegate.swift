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
      
      // 1. Listen for Screen Recording / Mirroring changes
              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(handleScreenCaptureChange),
                  name: UIScreen.capturedDidChangeNotification,
                  object: nil
              )
              
              // 2. Listen for Screenshots (Warning only - iOS blocks prevention)
              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(handleScreenshotTaken),
                  name: UIApplication.userDidTakeScreenshotNotification,
                  object: nil
              )
      
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
    
    // --- B. Handle Screen Recording ---
        @objc func handleScreenCaptureChange() {
            if UIScreen.main.isCaptured {
                // User started recording -> Blur immediately
                enablePrivacyScreen()
            } else {
                // User stopped recording -> Unblur
                disablePrivacyScreen()
            }
        }
        
        // --- C. Handle Screenshot (After the fact) ---
        @objc func handleScreenshotTaken() {
            // We can't stop the screenshot, but we can annoy the user or log it.
            let alert = UIAlertController(
                title: "Screenshot Detected",
                message: "For your security, please avoid taking screenshots of your private notes.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.window?.rootViewController?.present(alert, animated: true)
        }

        // --- Helper Functions ---
        func enablePrivacyScreen() {
            if privacyBlurView == nil {
                let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark) // Darker blur for privacy
                privacyBlurView = UIVisualEffectView(effect: blurEffect)
                
                if let window = self.window {
                    privacyBlurView?.frame = window.bounds
                    privacyBlurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    window.addSubview(privacyBlurView!)
                }
            }
        }

        func disablePrivacyScreen() {
            privacyBlurView?.removeFromSuperview()
            privacyBlurView = nil
        }
}
