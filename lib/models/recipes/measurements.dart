class Measurement {
  Measurements type;
  double quantity;
  late String parsedQuantity;

  Measurement({required this.type, required this.quantity}) {
    parsedQuantity = parseQuantity(quantity);
  }

  String parseQuantity(double quantity) {
    if (quantity % 1 == 0) {
      return quantity.toInt().toString();
    }
    else {
      return quantity.toString();
    }

  }

  /// Returns a user-friendly formatted representation of how much of an ingredient is required
  String formatMeasurement() {
    return switch(type) {
      Measurements.weightMetric => "$parsedQuantity g",
      Measurements.weightImperial => "$parsedQuantity lbs",
      Measurements.volume => "$parsedQuantity ml",
      Measurements.cups => "$parsedQuantity ${quantity == 1 ? "cup" : "cups"}",
      Measurements.tbsp => "$parsedQuantity tbsp",
      Measurements.tsp => "$parsedQuantity tsp",
      Measurements.quantity => parsedQuantity,
    };
  }
}

enum Measurements {
  weightMetric,
  weightImperial,
  volume,
  cups,
  tbsp,
  tsp,
  quantity,
}