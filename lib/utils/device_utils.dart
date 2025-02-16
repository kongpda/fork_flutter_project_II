import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class DeviceUtils {
  static Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Simple physical device check
        if (!androidInfo.isPhysicalDevice) {
          return 'Android Emulator';
        }
        return androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        if (!iosInfo.isPhysicalDevice) {
          return 'iOS Simulator';
        }
        return iosInfo.name;
      }
      return 'Unknown Device';
    } catch (e) {
      return 'Unknown Device';
    }
  }
}
