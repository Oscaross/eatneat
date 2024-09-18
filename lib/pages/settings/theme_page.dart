import 'package:eatneat/ui/safe_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemePage extends StatefulWidget {
  @override
  ThemePageState createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {

  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
              ],
            ),
          ),
        ]
      )
    );
  }

}