import Flutter
import UIKit

private let privacyBlurViewTag = 0x70726976

enum PrivacyScreen {
    static func enable(on window: UIWindow?, style: UIBlurEffect.Style = .systemThinMaterial) {
        guard let window = window else {
            return
        }

        if window.viewWithTag(privacyBlurViewTag) != nil {
            return
        }

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.tag = privacyBlurViewTag
        blurView.frame = window.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(blurView)
    }

    static func enable(on scene: UIScene, style: UIBlurEffect.Style = .systemThinMaterial) {
        enable(on: window(for: scene), style: style)
    }

    static func enableOnActiveWindows(style: UIBlurEffect.Style = .systemThinMaterial) {
        windows.forEach { enable(on: $0, style: style) }
    }

    static func disable(on window: UIWindow?) {
        window?.viewWithTag(privacyBlurViewTag)?.removeFromSuperview()
    }

    static func disable(on scene: UIScene) {
        disable(on: window(for: scene))
    }

    static func disableFromAllWindows() {
        windows.forEach { disable(on: $0) }
    }

    static var topViewController: UIViewController? {
        topViewController(from: keyWindow?.rootViewController)
    }

    private static var keyWindow: UIWindow? {
        windows.first(where: \.isKeyWindow)
    }

    private static var windows: [UIWindow] {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
    }

    private static func window(for scene: UIScene) -> UIWindow? {
        guard let windowScene = scene as? UIWindowScene else {
            return nil
        }

        return windowScene.windows.first(where: \.isKeyWindow) ?? windowScene.windows.first
    }

    private static func topViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        }

        return viewController
    }
}

@available(iOS 13.0, *)
@objc(PrivacySceneDelegate)
class PrivacySceneDelegate: FlutterSceneDelegate {
    override func sceneWillResignActive(_ scene: UIScene) {
        PrivacyScreen.enable(on: scene)
        super.sceneWillResignActive(scene)
    }

    override func sceneDidBecomeActive(_ scene: UIScene) {
        if !UIScreen.main.isCaptured {
            PrivacyScreen.disable(on: scene)
        }

        super.sceneDidBecomeActive(scene)
    }
}
