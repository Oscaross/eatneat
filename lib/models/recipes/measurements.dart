class Measurement {
  Measurements type;
  double quantity;

  Measurement({required this.type, required this.quantity});

  /// Returns a user-friendly formatted representation of how much of an ingredient is required
  String formatMeasurement() {
    return switch(type) {
      Measurements.weightMetric => "$quantity g",
      Measurements.weightImperial => "$quantity lbs",
      Measurements.volume => "$quantity ml",
      Measurements.cups => "$quantity ${quantity == 1 ? "cup" : "cups"}",
      Measurements.tbsp => "$quantity tbsp",
      Measurements.tsp => "$quantity tsp",
      Measurements.quantity => "$quantity",
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