import 'package:flutter/material.dart';

class LabelItem {

  String name;
  Color color;

  LabelItem({required this.name, required this.color});

  void updateName(String name) {
    this.name = name;
  }

  void updateColor(Color color) {
    this.color = color;
  }
}