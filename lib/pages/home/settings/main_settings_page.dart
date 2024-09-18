import 'package:eatneat/pages/home/settings/appearance_settings.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:flutter/material.dart';

class MainSettingsPage extends StatelessWidget {

  static final List<SettingsPage> _settingsPages = [
    SettingsPage(title: "Appearance", page: AppearanceSettingsPage()),
    SettingsPage(title: "Notifications", page: AppearanceSettingsPage()),
    SettingsPage(title: "Accessibility", page: AppearanceSettingsPage()),
    SettingsPage(title: "Privacy", page: AppearanceSettingsPage()),
    SettingsPage(title: "About", page: AppearanceSettingsPage()),
    SettingsPage(title: "Help & Support", page: AppearanceSettingsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.large),
          child: Center(
            child: Text("Settings", style: Theme.of(context).textTheme.displayMedium),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(), // can't scroll through this list
            itemCount: _settingsPages.length,
            itemBuilder: (context, index) => drawSettingsPageTab(_settingsPages[index], context),
          ),
        )
      ]
    );
  }

  Widget drawSettingsPageTab(SettingsPage page, BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
            child: Text(
              page.title, 
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
          Expanded(child: Center()),
          Icon(Icons.arrow_forward_ios),
        ]
      ),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page.page));
      }
    );
  }

}

class SettingsPage {
  final String title;
  final StatefulWidget page;

  SettingsPage({required this.title, required this.page});
}