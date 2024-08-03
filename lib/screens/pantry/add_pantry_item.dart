import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  static const double LABEL_SPACING = 20;

  final TextEditingController _nameController = TextEditingController();
  
  double _qty = 0;
  bool _isQuantity = true; // true for a quantity (ie. 3 chicken breast), false for kgs

  // Expiry management system
  DateTime? _expires;

  // Open the calendar dialog, at some point in the future we expect a date to be picked but no result back from this call - hence it is void.
  Future<void> selectDate(BuildContext context) async {
    final DateTime? expiry = await showDatePicker(
      context:context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Can't have something expire before now!
      lastDate: DateTime(2100), // An arbitrarily large end window - could potentially be changed...
    );

    if(expiry != null && expiry != _expires) {
      setState(() {
        _expires = expiry;
      });
    }
  }

  LabelItem? selectedLabel;

  @override
  Widget build(BuildContext context) {
    var labelProvider = Provider.of<LabelProvider>(context);
    selectedLabel = labelProvider.selectedLabel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Pantry Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                  child: TextField(
                    autocorrect: true,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText:"Item Name"
                    ),
                    keyboardType:TextInputType.text,)
                    ),
            // Break up the space between the item name and quantity input
            SizedBox(height: LABEL_SPACING),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SpinBox(
                    value: _qty,
                    onChanged: (value) {
                      setState(() {
                        _qty = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                    ),
                    min: 0,
                    max:100000,
                    // If we are entering a qty (quantity) then step by 1, otherwise for grams step by 100
                    step: (_isQuantity) ? 1 : 100,
                    decimals: 1,
                  ),
                ),

                SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(20),
                      isSelected: [_isQuantity, !_isQuantity],
                      onPressed: (int index) {
                        setState(() {
                          _isQuantity = index == 0;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('qty'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('gram'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: LABEL_SPACING*1.5),
            InkWell(
              onTap: () => selectDate(context),
              child: InputDecorator(decoration: InputDecoration(
                labelText: "Expires on",
                border: OutlineInputBorder(),
              ),
              child: Text(
              _expires == null ? "None specified" : '${_expires!.day}/${_expires!.month}/${_expires!.year}',
              ),
              )
            ),
            SizedBox(height: LABEL_SPACING),

            DropdownButton<LabelItem>(
                value: selectedLabel,
                items: labelProvider.labels.map((label) {
                  return DropdownMenuItem<LabelItem>(
                    value: label,
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: label.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(label.getName(), style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (LabelItem? newLabel) {
                  setState(() {
                    selectedLabel = newLabel;
                  });
                },
              ),

            SizedBox(height:LABEL_SPACING),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add item to pantry logic
                  var name = _nameController.text;
                  
                  if(_qty != 0 && _qty > 0 && _expires != null) {
                    var pantryItem = PantryItem(expiry: _expires!, name: name, quantity: _qty, isQuantity: _isQuantity, added: DateTime.now(), label: selectedLabel);
                    Provider.of<PantryProvider>(context, listen:false).addItem(pantryItem);
                  }
                  else {
                    print("Error validating input to Pantry!");
                  }
                  
                  Navigator.pop(context);
                },
                child: Text(
                  'Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
