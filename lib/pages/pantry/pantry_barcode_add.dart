import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';

class PantryBarcodeAddPage extends StatefulWidget {

  final PantryItem item;

  PantryBarcodeAddPage({required this.item});

  @override
  _PantryBarcodeAddPage createState() => _PantryBarcodeAddPage();
}

class _PantryBarcodeAddPage extends State<PantryBarcodeAddPage> {

  @override
  Widget build(BuildContext context) {
    
    return Text(widget.item.name);
  }
}