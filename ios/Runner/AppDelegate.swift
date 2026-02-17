import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    let scanChannel = FlutterMethodChannel(
        name: "crime_scene_scanner",
        binaryMessenger: controller.binaryMessenger
    )

    scanChannel.setMethodCallHandler { [weak self] call, result in
        if call.method == "startScan" {
            self?.presentScanner(from: controller)
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func presentScanner(from controller: FlutterViewController) {
      let scannerVC = CrimeSceneScannerViewController()
      scannerVC.modalPresentationStyle = .fullScreen
      controller.present(scannerVC, animated: true)
  }
}
