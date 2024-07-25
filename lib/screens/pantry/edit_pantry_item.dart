import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:provider/provider.dart';
import '../../providers/pantry_provider.dart';

class EditItemPage extends StatefulWidget {
  final PantryItem item;

  EditItemPage({required this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late bool _isQuantity;
  late DateTime _expires;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
    _isQuantity = widget.item.isQuantity;
    _expires = widget.item.expiry;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expires,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _expires) {
      setState(() {
        _expires = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity Type:'),
                ToggleButtons(
                  isSelected: [_isQuantity, !_isQuantity],
                  onPressed: (int index) {
                    setState(() {
                      _isQuantity = index == 0;
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Units'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Grams'),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                ),
                child: Text(_expires == null ? 'None' : '${_expires.toLocal()}'.split(' ')[0]),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update item in pantry logic
                widget.item.setName(_nameController.text);
                widget.item.setQuantity(double.parse(_quantityController.text));
                widget.item.setIsQuantity(_isQuantity);
                widget.item.setExpiry(_expires);
                // Change state
                Provider.of<PantryProvider>(context, listen:false).triggerUpdate();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
