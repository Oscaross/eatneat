import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  @override
  ShoppingPageState createState() => ShoppingPageState();
}

class ShoppingPageState extends State<ShoppingPage> {

  static const int spacerFlex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping")
      ),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: spacerFlex),
            // Expiring soon widget
            Flexible(
              flex: 8,
              child: buildContainer(buildExpiringSoonCard()),
            ),
            Spacer(flex: spacerFlex),
            Flexible(
              flex: 6,
              child: buildContainer(Center()),
            ),
            Spacer(flex: spacerFlex),
            Padding(
              padding: SafePadding.getSafePadding(context: context, marginType: MarginType.left, paddingType: PaddingType.large),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "History",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Spacer(flex: spacerFlex),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(child: buildContainer(Center())),
                  Expanded(child: buildContainer(Center())),
                ]
              )
            )
          ]
        ),
      )
    );
  }

  Widget buildContainer(Widget child) {
    return Padding(
      padding: SafePadding.getSafePadding(context: context, marginType: MarginType.horizontal, paddingType: PaddingType.large),
      child: Container(
        decoration: Themes.decorateContainer(),
        child: child,
      )
    );
  }

  Widget buildExpiringSoonCard() {
    return Center();
  }
}