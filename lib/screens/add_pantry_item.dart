import 'package:flutter/material.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  static const double LABEL_SPACING = 20;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
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

  @override
  Widget build(BuildContext context) {
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
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
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
                          child: Text('kgs'),
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add item to pantry logic
                  print('Quantity: ${_quantityController.text}');
                  print('Unit: ${_isQuantity ? 'qty' : 'kgs'}');
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
