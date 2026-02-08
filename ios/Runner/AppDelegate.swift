import UIKit
import Flutter
import ARKit
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()

    let controller = window?.rootViewController as! FlutterViewController

    let lidarChannel = FlutterMethodChannel(
      name: "liscan/lidar",
      binaryMessenger: controller.binaryMessenger
    )

    lidarChannel.setMethodCallHandler { call, result in
      if call.method == "isSupported" {
        if #available(iOS 13.4, *) {
          result(ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh))
        } else {
          result(false)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
