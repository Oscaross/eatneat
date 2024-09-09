import 'package:eatneat/pages/preferences/theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferencesPage extends StatelessWidget {

  final List<String> pages = ["Account", "Privacy", "Theme", "Notifications", "About"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings")
      ),
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blue.withOpacity(0.07),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: generatePageTile(pages[index]),
              onTap: () {
                  
                HapticFeedback.lightImpact();
                Widget route =
                  switch(pages[index]) {
                    "Theme" => ThemePage(),
                    _ => PreferencesPage(),
                  };
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => route)
                );
                  
                  
              }
            ),
          );
        },
      )
    );
  }

  Widget generatePageTile(String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: generatePageIcon(label),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )
                )
              ),
            ),
            Spacer(flex:2),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ],
    );
  }

  Icon generatePageIcon(String label) {
    return switch(label) {
      "Account" => Icon(Icons.person, color:Colors.grey[800]),
      "Privacy" => Icon(Icons.privacy_tip, color:Colors.grey[800]),
      "Theme" => Icon(Icons.brush, color:Colors.grey[800]),
      "Notifications" => Icon(Icons.notifications, color:Colors.grey[800]),
      "About" => Icon(Icons.more_horiz, color:Colors.grey[800]),
      _ => throw ArgumentError("Error generating view for preferences page! Illegal icon generated.")
    };
  }

}