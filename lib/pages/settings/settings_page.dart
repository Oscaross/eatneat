import 'package:eatneat/pages/settings/theme_page.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferencesPage extends StatelessWidget {

  final List<SettingsPageObject> pageObjects = [
    SettingsPageObject(pageIcon: Icons.brush, pageName: "Theme", route: MaterialPageRoute(builder: (context) => ThemePage())),
    SettingsPageObject(pageIcon: Icons.person, pageName: "Account", route: MaterialPageRoute(builder: (context) => ThemePage())),
    SettingsPageObject(pageIcon: Icons.lock, pageName: "Privacy", route: MaterialPageRoute(builder: (context) => ThemePage())),
    SettingsPageObject(pageIcon: Icons.notifications, pageName: "Notifications", route: MaterialPageRoute(builder: (context) => ThemePage())),
    SettingsPageObject(pageIcon: Icons.info, pageName: "About", route: MaterialPageRoute(builder: (context) => ThemePage())),
    SettingsPageObject(pageIcon: Icons.help, pageName: "Help & Support", route: MaterialPageRoute(builder: (context) => ThemePage())),

  ];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: deviceSize.width * 0.02, mainAxisSpacing: deviceSize.height * 0.02),
          itemCount: pageObjects.length,
          itemBuilder: (context, index) => Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.generous),
            child: buildSettingsPageContainer(pageObjects[index], context)
          )
        ),
      )
    );
  }

  Widget buildSettingsPageContainer(SettingsPageObject pageObject, BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: Themes.decorateContainer(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon to describe our settings page
            Padding(
              padding: SafePadding.getSafePadding(context: context, marginType: MarginType.bottom, paddingType: PaddingType.medium),
              child: Icon(
                pageObject.pageIcon,
                size: 50,
                color: Colors.grey.shade800.withOpacity(0.95),
              ),
            ),
            // title of settings page
            Text(pageObject.pageName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        )
      ),
      onTap: () {
        Navigator.push(context, pageObject.route);
        HapticFeedback.selectionClick();
      }
    );
  }
}

class SettingsPageObject {

  final IconData pageIcon;
  final String pageName;
  final MaterialPageRoute route;

  SettingsPageObject({required this.pageIcon, required this.pageName, required this.route});
}