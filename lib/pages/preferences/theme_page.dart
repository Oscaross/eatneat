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
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Theme")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode", style: TextStyle(color: Colors.grey[800], fontSize: 17, fontWeight: FontWeight.w600)),
                Switch(
                  thumbIcon: WidgetStatePropertyAll(Icon((_darkMode) ? Icons.mode_night : Icons.sunny, size: 20)),
                  trackColor: WidgetStatePropertyAll(Colors.grey[700]),
                  value: _darkMode,
                  onChanged: (darkMode) {
                    setState(() {
                      _darkMode = darkMode;
                    });
                
                    HapticFeedback.lightImpact();
                  }
                
                ),
              ],
            ),
          ),
        ]
      )
    );
  }

}