import 'package:flutter/material.dart';

// Provides a safe and scalable static padding system to avoid padding by const pixel values; uses MediaQuery.of() to ensure padding is consistent over devices
class SafePadding {

  /// Return an EdgeInsets instance of the required padding, scaled to the parameters and the device margins.
  static EdgeInsets getSafePadding({required BuildContext context, required MarginType marginType, PaddingType? paddingType, double? customMultiplier}) {

    // Argument checks
    assert((paddingType != null) != (customMultiplier != null), "getSafePadding must be provided with exactly one of the parameters paddingType or customMultiplier.");

    double multiplier = 0;

    if(paddingType != null) {
      multiplier = _getMultiplierByPaddingType(paddingType);
    }
    else {
      multiplier = customMultiplier!; // null safe because of prior assertion that both cannot be null
    }

    Size deviceSize = MediaQuery.of(context).size;

    return switch (marginType) {
      MarginType.all => EdgeInsets.all(deviceSize.width * multiplier),
      MarginType.vertical => EdgeInsets.fromLTRB(0, (deviceSize.height * multiplier) / 2, 0, (deviceSize.height * multiplier) / 2),
      MarginType.horizontal => EdgeInsets.fromLTRB(deviceSize.width * multiplier, 0, deviceSize.width * multiplier, 0),
      MarginType.left => EdgeInsets.only(left: deviceSize.width * multiplier),
      MarginType.right => EdgeInsets.only(right: deviceSize.width * multiplier),
      MarginType.top => EdgeInsets.only(top: deviceSize.height * multiplier),
      MarginType.bottom => EdgeInsets.only(bottom: deviceSize.height * multiplier)
    };
  }

  static double _getMultiplierByPaddingType(PaddingType type) {
    return switch(type) {
      PaddingType.small => 0.005,
      PaddingType.medium => 0.02,
      PaddingType.large => 0.04,
      PaddingType.generous => 0.08,
      PaddingType.none => 0,
    };
  }
}

/// Allows customisation of the amount of padding given based on some constant values.
enum PaddingType {
  none,
  small,
  medium,
  large,
  generous
}

enum MarginType {
  all,
  vertical,
  horizontal,
  left,
  right,
  top,
  bottom
}