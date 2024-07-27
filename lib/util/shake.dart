import 'package:vibration/vibration.dart';

class Shaker {
  // Static method to vibrate the device for the specified duration
  static Future<void> vibrate(int millis) async {
    bool? hasVibrator = await Vibration.hasVibrator();
    // Check if the device supports vibration
    if (hasVibrator!) {
      // Vibrate for the specified duration
      Vibration.vibrate(duration: millis);
    }
  }
}
