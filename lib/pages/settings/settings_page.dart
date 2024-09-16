import 'package:eatneat/pages/settings/theme_page.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferencesPage extends StatelessWidget {

  final List<SettingsPageObject> pageObjects = [
    SettingsPageObject(pageIcon: Icons.brush, pageName: "Theme", page: ThemePage()),
    SettingsPageObject(pageIcon: Icons.person, pageName: "Account", page: ThemePage()),
    SettingsPageObject(pageIcon: Icons.lock, pageName: "Privacy", page: ThemePage()),
    SettingsPageObject(pageIcon: Icons.notifications, pageName: "Notifications", page: ThemePage()),
    SettingsPageObject(pageIcon: Icons.info, pageName: "About", page: ThemePage()),
    SettingsPageObject(pageIcon: Icons.question_mark_rounded, pageName: "Help & Support", page: ThemePage()),

  ];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings")
      ),
      body: Padding(
        padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: deviceSize.width * 0.03, mainAxisSpacing: deviceSize.width * 0.03),
          itemCount: pageObjects.length,
          itemBuilder: (context, index) => buildSettingsPageContainer(pageObjects[index], context)
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
            Padding(
              padding: SafePadding.getSafePadding(context: context, marginType: MarginType.bottom, paddingType: PaddingType.medium),
              child: Icon(
                pageObject.pageIcon,
                size: 52,
                color: Themes.primaryAccent.withOpacity(0.85),
                semanticLabel: pageObject.pageName,
              ),
            ),
            Text(pageObject.pageName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Themes.primary)),
          ],
        )
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageObject.page));
        HapticFeedback.selectionClick();
      }
    );
  }
}

class SettingsPageObject {

  final IconData pageIcon;
  final String pageName;
  final StatefulWidget page;

  SettingsPageObject({required this.pageIcon, required this.pageName, required this.page});
}