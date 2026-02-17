import UIKit
import RealityKit
import ARKit

class CrimeSceneScannerViewController: UIViewController, ARSessionDelegate {

    var arView: ARView!
    var saveButton: UIButton!
    var isScanning = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupSaveButton()
        startScanning()
    }

    // MARK: - Setup ARView

    func setupARView() {
        arView = ARView(frame: .zero)
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)

        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        arView.session.delegate = self
    }

    // MARK: - Start LiDAR Scan

    func startScanning() {

        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            print("LiDAR not supported")
            dismiss(animated: true)
            return
        }

        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic
        config.planeDetection = []

        arView.session.run(config)
    }

    // MARK: - Stop & Save Button

    func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.setTitle("STOP & SAVE", for: .normal)
        saveButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(stopAndSave), for: .touchUpInside)

        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 180),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Stop Scan & Save

    @objc func stopAndSave() {

        guard isScanning else { return }
        isScanning = false

        arView.session.pause()

        saveScene()
    }

    // MARK: - Save Mesh to USDZ

    func saveScene() {

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(arView.scene.anchors.first ?? AnchorEntity())
        arView.scene.addAnchor(anchor)

        let timestamp = generateTimestamp()
        let fileName = "CrimeScene_\(timestamp).usdz"

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)

        do {
            try arView.scene.export(to: fileURL)
            print("Saved at: \(fileURL)")
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }

        dismiss(animated: true)
    }

    // MARK: - Timestamp

    func generateTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: Date())
    }
}
