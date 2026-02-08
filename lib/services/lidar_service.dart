import 'package:flutter/services.dart';

class LidarService {
  static const MethodChannel _channel =
      MethodChannel('liscan/lidar');

  /// Check if LiDAR is supported on this device
  static Future<bool> isSupported() async {
    try {
      final bool supported =
          await _channel.invokeMethod('isSupported');
      return supported;
    } catch (e) {
      return false;
    }
  }
}
