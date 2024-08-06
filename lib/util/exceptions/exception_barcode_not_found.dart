class BarcodeNotFoundException implements Exception {
  final String barcode;

  BarcodeNotFoundException(this.barcode);

  @override
  String toString() {
    return "The API was sent a barcode but had no valid response! Barcode ID: $barcode";
  }
}