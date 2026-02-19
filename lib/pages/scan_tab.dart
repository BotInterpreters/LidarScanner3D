import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/scan_item.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({Key? key}) : super(key: key);

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  static const MethodChannel _lidarChannel =
      MethodChannel('crime_scene_scanner');

  List<ScanItem> scans = [];

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  // ---------------------------
  // START SCAN
  // ---------------------------

  Future<void> _startLidarScan() async {
    final result = await _lidarChannel.invokeMethod('startScan');

    if (result != null) {
      setState(() {
        scans.add(
          ScanItem(
            usdzPath: result['usdz'],
            thumbnailPath: result['thumbnail'],
            date: DateTime.now(),
          ),
        );
      });
    }
  }

  // ---------------------------
  // LOAD SCANS (PERSISTENCE)
  // ---------------------------

  Future<void> _loadScans() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();

    for (var file in files) {
      if (file.path.endsWith(".usdz")) {
        final thumb = file.path.replaceAll(".usdz", ".jpg");

        if (File(thumb).existsSync()) {
          scans.add(
            ScanItem(
              usdzPath: file.path,
              thumbnailPath: thumb,
              date: File(file.path).lastModifiedSync(),
            ),
          );
        }
      }
    }

    setState(() {});
  }

  // ---------------------------
  // DELETE SCAN
  // ---------------------------

  void _deleteScan(int index) async {
    final scan = scans[index];

    await File(scan.usdzPath).delete();
    await File(scan.thumbnailPath).delete();

    setState(() {
      scans.removeAt(index);
    });
  }

  // ---------------------------
  // OPEN 3D PREVIEW
  // ---------------------------

  void _openPreview(ScanItem scan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Scan Preview")),
          body: ModelViewer(
            src: "file://${scan.usdzPath}",
            autoRotate: true,
            cameraControls: true,
          ),
        ),
      ),
    );
  }

  // ---------------------------
  // FORMAT DATE
  // ---------------------------

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  // ---------------------------
  // UI
  // ---------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060C2E),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Scan Button
          ElevatedButton(
            onPressed: _startLidarScan,
            child: const Text("Start Scan"),
          ),

          const SizedBox(height: 20),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: scans.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final scan = scans[index];

                return GestureDetector(
                  onTap: () => _openPreview(scan),
                  onLongPress: () => _deleteScan(index),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(scan.thumbnailPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(scan.date),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
