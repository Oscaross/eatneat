import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionsDialog extends StatefulWidget {
  final List<OptionDialogAction> actionItems;
  final Rect pos;

  OptionsDialog({required this.actionItems, required this.pos});

  @override 
  OptionsDialogState createState() => OptionsDialogState();
}

class OptionsDialogState extends State<OptionsDialog> {

  final OverlayPortalController _controller = OverlayPortalController();
  late Rect _pos;
  List<OptionDialogAction> _actionItems = [];

  @override
  void initState() {
    _actionItems = widget.actionItems;
    _pos = widget.pos;

    super.initState();
  }

  void showDialog() {
    
    

  }

  void closeDialog() {
    print("Close dialog");
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    // spawn the overlay portal at the bottom right location of its parent widget
    return Positioned(
      top: _pos.bottom,
      right: _pos.right,
      width: deviceSize.width * 0.4,
      height: deviceSize.height * 0.3,
      child: buildListContainer(context),
    );
  }

  Widget buildListContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(  
        color: Themes.overlayColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              style: Themes.decorateIconButton(ButtonType.subtle),
              onPressed: () {
                HapticFeedback.mediumImpact();
                closeDialog();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _actionItems.length,
              itemBuilder: (context, index) => buildListTile(_actionItems[index])
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(OptionDialogAction actionItem) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        actionItem.onPressed();
      },
      child: Padding(
        padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
        child: Row(
          children: <Widget> [
            Icon(
              actionItem.leadingIcon,
              color: (actionItem.important) ? Colors.redAccent : Themes.background,
            ),
            Expanded(child: Center()),
            Text(
              actionItem.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: (actionItem.important) ? Colors.redAccent : Themes.background,
                fontWeight: FontWeight.w700,
              )
            )
          ]
        ),
      ),
    );
  }
}

class OptionDialogAction {

  String title;
  IconData leadingIcon;
  // 'important' actions are ones which should have confirmation screens and be highlighted 
  bool important;
  void Function() onPressed;

  OptionDialogAction({
    required this.title,
    required this.leadingIcon,
    this.important = false,
    required this.onPressed,
  });
}