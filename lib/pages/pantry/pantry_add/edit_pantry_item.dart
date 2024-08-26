import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:provider/provider.dart';
import '../../../providers/pantry_provider.dart';

class EditItemPage extends StatefulWidget {
  final PantryItem item;

  EditItemPage({required this.item});

  @override
  EditItemPageState createState() => EditItemPageState();
}

class EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late DateTime _expires;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _weightController = TextEditingController(text: widget.item.weight.toString());
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
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                ),
                child: Text('${_expires.toLocal()}'.split(' ')[0]),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update item in pantry logic
                widget.item.setName(_nameController.text);
                widget.item.setWeight(double.parse(_weightController.text));
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
