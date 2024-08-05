// Internal class to help with debugging. DO NOT SHIP WITH APP!

import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';

class Debug {
  LabelItem meat = LabelItem(name: "Meat",color: Colors.red);
  LabelItem veg = LabelItem(name: "Veg", color: Colors.green);
  LabelItem carbs = LabelItem(name: "Carbs", color: Colors.orange);

  PantryItem chicken = PantryItem(name: "Chicken Breast", added: DateTime.now(), quantity: 300, isQuantity: false, expiry: DateTime.now().add(const Duration(days:10)));
  PantryItem steak = PantryItem(name: "Elephant Steak", added: DateTime.now(), quantity: 2, isQuantity: true, expiry: DateTime.now().add(const Duration(days:2)));
  PantryItem pork = PantryItem(name: "Pork Chops", added: DateTime.now(), quantity: 300, isQuantity: false, expiry: DateTime.now().add(const Duration(days:30)));
  PantryItem sweetcorn = PantryItem(name: "Sweetcorn", added: DateTime.now(), quantity: 2, isQuantity: true, expiry: DateTime.now().add(const Duration(days:7)));

  void configure(PantryProvider provider, LabelProvider provider2) {
    chicken.label = meat;
    steak.label = meat;
    pork.label = meat;
    sweetcorn.label = veg;

    provider.addItem(chicken);
    provider.addItem(steak);
    provider.addItem(pork);
    provider.addItem(sweetcorn);

    provider2.createNewLabel(meat);
    provider2.createNewLabel(veg);
    provider2.createNewLabel(carbs);
  }
}