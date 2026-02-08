import 'package:flutter/material.dart';
import '../services/lidar_service.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  String _status = 'Checking LiDAR support…';

  @override
  void initState() {
    super.initState();
    _checkLidar();
  }

  Future<void> _checkLidar() async {
    final supported = await LidarService.isSupported();

    setState(() {
      _status = supported
          ? 'LiDAR supported — ready to scan'
          : 'LiDAR not supported on this device';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _status,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
