// Internal class to help with debugging. DO NOT SHIP WITH APP!

import 'package:flutter/material.dart';
import 'package:eatneat/models/label_item.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:eatneat/providers/label_provider.dart';
import 'package:eatneat/providers/pantry_provider.dart';

class Debug {
  LabelItem meat = LabelItem(name: "Meat",color: Colors.red);
  LabelItem cold = LabelItem(name: "Cold", color: Colors.blue);
  LabelItem carbs = LabelItem(name: "Carbs", color: Colors.orange);

  Set<LabelItem> setOne = {};
  Set<LabelItem> setTwo = {};

  void configure(PantryProvider provider, LabelProvider provider2) {
    PantryItem chicken = PantryItem(name: "Chicken Breast", added: DateTime.now(), weight: 300, expiry: DateTime.now().add(const Duration(days:10)), quantity: 3, labelSet: setOne);
    PantryItem steak = PantryItem(name: "Elephant Steak", added: DateTime.now(), weight: 0, expiry: DateTime.now().add(const Duration(days:2)), quantity:2, labelSet: setOne);
    PantryItem pork = PantryItem(name: "No Label!", added: DateTime.now(), weight: 300, expiry: DateTime.now().add(const Duration(days:30)), quantity: 1, labelSet: {});
    PantryItem sweetcorn = PantryItem(name: "Sweetcorn", added: DateTime.now(), weight: 150, expiry: DateTime.now().add(const Duration(days:7)), quantity: 3, labelSet: setTwo);
    PantryItem fuckUpMyAppPlease = PantryItem(name: "Deal with this lol", added: DateTime.now(), weight: 1200, expiry: DateTime.now(), quantity: 1, labelSet: {});
    PantryItem fish = PantryItem(name: "Fish", added: DateTime.now(), weight: 500, expiry: DateTime.now().add(const Duration(days:30)), quantity: 1, labelSet: {});

    setOne.add(meat);
    setOne.add(cold);
    setTwo.add(carbs);

    chicken.addLabel(setOne);
    steak.addLabel(setOne);
    pork.addLabel(setOne);

    provider.addItem(chicken);
    provider.addItem(steak);
    provider.addItem(pork);
    provider.addItem(sweetcorn);

    PantryCategory canned = PantryCategory(name: "Canned Foods");
    PantryCategory bread = PantryCategory(name: "Bread");
    PantryCategory condiments = PantryCategory(name: "Condiments");

    provider.categories.add(canned);
    provider.categories.add(bread);
    provider.categories.add(condiments);

    canned.addToCategory(sweetcorn);
    bread.addToCategory(steak);
    bread.addToCategory(pork);
    bread.addToCategory(chicken);
    bread.addToCategory(fish);
    bread.addToCategory(fuckUpMyAppPlease);

    provider2.createNewLabel(meat);
    provider2.createNewLabel(cold);
    provider2.createNewLabel(carbs);
  }
}