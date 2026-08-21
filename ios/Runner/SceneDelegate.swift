import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private let privacyBlurViewTag = 0x70726976
  private var wasScreenCaptured = false

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )

    guard let windowScene = scene as? UIWindowScene else {
      return
    }

    windowScene.registerForTraitChanges([UITraitSceneCaptureState.self]) {
      [weak self] (scene: UIWindowScene, _) in
      self?.handleCaptureState(isCaptured: scene.traitCollection.sceneCaptureState == .active)
    }
  }

  override func sceneWillResignActive(_ scene: UIScene) {
    addPrivacyBlur()
    super.sceneWillResignActive(scene)
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    removePrivacyBlur()
    super.sceneDidBecomeActive(scene)

    guard let windowScene = scene as? UIWindowScene else {
      return
    }

    handleCaptureState(isCaptured: isScreenCaptured(in: windowScene))
  }

  @objc private func handleScreenshot() {
    presentWarning(
      title: "Screenshot Detected",
      message: "Screenshots can expose your private notes. Please keep the captured image secure or delete it."
    )
  }

  private func handleCaptureState(isCaptured: Bool) {
    defer { wasScreenCaptured = isCaptured }

    guard isCaptured, !wasScreenCaptured else {
      return
    }

    presentWarning(
      title: "Screen Recording Detected",
      message: "Screen recording or mirroring can expose your private notes. Stop capturing before viewing sensitive information."
    )
  }

  private func isScreenCaptured(in windowScene: UIWindowScene) -> Bool {
    windowScene.traitCollection.sceneCaptureState == .active
  }

  private func addPrivacyBlur() {
    guard let window, window.viewWithTag(privacyBlurViewTag) == nil else {
      return
    }

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    blurView.tag = privacyBlurViewTag
    blurView.frame = window.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(blurView)
  }

  private func removePrivacyBlur() {
    window?.viewWithTag(privacyBlurViewTag)?.removeFromSuperview()
  }

  private func presentWarning(title: String, message: String) {
    guard
      let rootViewController = window?.rootViewController,
      let presenter = topViewController(from: rootViewController),
      !(presenter is UIAlertController)
    else {
      return
    }

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    presenter.present(alert, animated: true)
  }

  private func topViewController(from viewController: UIViewController) -> UIViewController? {
    if let presentedViewController = viewController.presentedViewController {
      return topViewController(from: presentedViewController)
    }

    if let navigationController = viewController as? UINavigationController,
      let visibleViewController = navigationController.visibleViewController
    {
      return topViewController(from: visibleViewController)
    }

    if let tabBarController = viewController as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController
    {
      return topViewController(from: selectedViewController)
    }

    return viewController
  }

}
