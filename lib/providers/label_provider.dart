import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';

class LabelProvider with ChangeNotifier {
  List<LabelItem> _labels = [];
  List<LabelItem> get labels => _labels;

  void _createNewLabel(LabelItem label) {
    _labels.add(label);
    notifyListeners();
  }
}