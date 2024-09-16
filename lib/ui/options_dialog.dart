import 'package:flutter/material.dart';

class OptionsDialog extends StatefulWidget {
  final List<OptionDialogAction> actionItems;

  OptionsDialog({required this.actionItems});

  @override 
  OptionsDialogState createState() => OptionsDialogState();
}

class OptionsDialogState extends State<OptionsDialog> {

  final OverlayPortalController _controller = OverlayPortalController();
  List<OptionDialogAction> _actionItems = [];

  @override
  void initState() {
    _actionItems = widget.actionItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    // TODO: implement build
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) => Positioned(
        height: deviceSize.height * 0.4,
        width: deviceSize.width * 0.3,
        child: Container(width: double.infinity, height: double.infinity, color: Colors.red),
      )
    );
  }
}

class OptionDialogAction {

  String title;
  Icon leadingIcon;
  void Function() onPressed;

  OptionDialogAction({required this.title, required this.leadingIcon, required this.onPressed});
}