import 'package:flutter/services.dart';

class LidarChannel {
  static const MethodChannel _channel =
      MethodChannel('lidar_scanner');

  static Future<void> startScan() async {
    try {
      await _channel.invokeMethod('startScan');
    } catch (e) {
      print('LiDAR error: $e');
    }
  }
}
