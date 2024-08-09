import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';

class LabelProvider with ChangeNotifier {
  // The label that is selected on the pantry page
  LabelItem? selectedLabel;
  List<LabelItem> _labels = [];
  List<LabelItem> get labels => _labels;

  // A list of the labels the user has selected - this object must be a set as we cannot have two instances of the same LabelItem selected at once.
  Set<LabelItem> selectedLabels = {};

  final ButtonStyle addButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.blueAccent),
    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    ),
    side: WidgetStatePropertyAll<BorderSide>(
      BorderSide(color: Colors.blueAccent, width: 2.0),
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    elevation: WidgetStatePropertyAll<double>(0.0),
  );
  
  void createNewLabel(LabelItem label) {
    _labels.add(label);
    notifyListeners();
  }

  void toggleLabel(LabelItem label) {
    // If the label is already selected, remove it and set its boolean flag to deselected
    if(selectedLabels.contains(label)) {
      selectedLabels.remove(label);
      label.isSelected = false;
    }
    // Otherwise select it
    else {
      selectedLabels.add(label);
      label.isSelected = true;
    }

    // Then 
  }


}