import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    func didInitializeImplicitFlutterEngine(
        _ engineBridge: FlutterImplicitEngineBridge
    ) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {

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

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    // --- B. Handle Screen Recording ---
    @objc func handleScreenCaptureChange() {
        if UIScreen.main.isCaptured {
            // User started recording -> Blur immediately
            PrivacyScreen.enableOnActiveWindows(style: .systemUltraThinMaterialDark)
        } else {
            // User stopped recording -> Unblur
            if UIApplication.shared.applicationState == .active {
                PrivacyScreen.disableFromAllWindows()
            }
        }
    }

    // --- C. Handle Screenshot (After the fact) ---
    @objc func handleScreenshotTaken() {
        // We can't stop the screenshot, but we can annoy the user or log it.
        let alert = UIAlertController(
            title: "Screenshot Detected",
            message:
                "For your security, please avoid taking screenshots of your private notes.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        PrivacyScreen.topViewController?.present(alert, animated: true)
    }
}
