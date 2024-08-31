import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class Shaker {
  static Future<void> vibrate(int millis) async {
    bool? hasVibrator = await Vibration.hasVibrator();
    // Check if the device supports vibration
    if (hasVibrator!) {
      print("Trying to vibrate the device!");
      // Vibrate for the specified duration
      await Vibration.vibrate(duration: millis);
    }
  }

  static Future<void> tap() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    // Check if the device supports vibration
    if (hasVibrator!) {
      print("Simulating tap");
      // Vibrate for the specified duration
      HapticFeedback.lightImpact();
    }
  }
}
