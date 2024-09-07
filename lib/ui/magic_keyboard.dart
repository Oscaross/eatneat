import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Represents a numerical keypad that allows for quick, efficient and seemless modification of values such as quantity or weight

class MagicKeyboard extends StatefulWidget {
  final void Function(String val) onChanged;
  final void Function()? onNextPressed;

  MagicKeyboard({required this.onChanged, this.onNextPressed});

  @override
  MagicKeyboardState createState() => MagicKeyboardState();
}

class MagicKeyboardState extends State<MagicKeyboard> {

  final List<String> buttons = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "Next"];
  void Function()? onNextPressed;

  String _capturedInput = "";
  String get capturedInput => _capturedInput;

  // Can't let the user have more than one decimal point!
  bool _hasDecimalPoint = false;

  @override
  void initState() {
    onNextPressed = widget.onNextPressed;
    super.initState();
  }

  // TODO: Make it so the user can collapse the magic keyboard
  // TODO: Improve the animation for when the magic keyboard comes onto the screen

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.96,
      crossAxisCount: 3,
      // Take each button item in the list and convert it to an individual button widget
      children: buttons.map(
        (e) => generateKeyTile(e)).toList(growable: false),
    );
  }

  Widget generateKeyTile(String label) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            switch(label) {
              
              // If we have a next pressed action, great! Otherwise just do nothing
              case "Next":
                (onNextPressed == null) ? null : onNextPressed!();

              // Deal with the decimal point - either add it if we don't have one or ignore the command if it is not valid (we can only have one)
              case ".":
                if(!_hasDecimalPoint) {
                  _hasDecimalPoint = true;
                _capturedInput = _capturedInput + label;
                }
                
              // Default case is that we clicked a number
              default:
                _capturedInput = _capturedInput + label;
            }

            widget.onChanged(_capturedInput);
            
            SystemSound.play(SystemSoundType.click);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey[600]!.withOpacity(0.1)),
            surfaceTintColor: WidgetStatePropertyAll(Colors.grey[700]!.withOpacity(0.1)),
            overlayColor: WidgetStatePropertyAll(Colors.grey[700]!.withOpacity(0.15)),
            fixedSize: WidgetStatePropertyAll(MediaQuery.of(context).size * 0.08),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0), 
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            )
          ),
        ),
      ),
    );
  }
}