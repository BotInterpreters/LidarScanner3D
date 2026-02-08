import Flutter
import UIKit
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()

      // ✅ Flutter root controller
    let controller = window?.rootViewController as! FlutterViewController

    // ✅ LiDAR Method Channel
    let lidarChannel = FlutterMethodChannel(
      name: "lidar_scanner",
      binaryMessenger: controller.binaryMessenger
    )

    lidarChannel.setMethodCallHandler { call, result in
      if call.method == "startScan" {
        let lidarVC = LidarViewController()
        lidarVC.modalPresentationStyle = .fullScreen
        controller.present(lidarVC, animated: true)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
