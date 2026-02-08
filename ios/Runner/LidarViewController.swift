import UIKit
import ARKit

class LidarViewController: UIViewController, ARSessionDelegate {

  var arView: ARSCNView!

  override func viewDidLoad() {
    super.viewDidLoad()

    arView = ARSCNView(frame: view.bounds)
    arView.session.delegate = self
    arView.automaticallyUpdatesLighting = true

    view.addSubview(arView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard ARWorldTrackingConfiguration.isSupported else {
      fatalError("ARKit not supported")
    }

    let config = ARWorldTrackingConfiguration()

    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
      config.sceneReconstruction = .mesh
    }

    config.planeDetection = [.horizontal, .vertical]
    config.environmentTexturing = .automatic

    arView.session.run(config)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    arView.session.pause()
  }
}
