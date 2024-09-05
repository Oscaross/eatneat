import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Represents a numerical keypad that allows for quick, efficient and seemless modification of values such as quantity or weight

class MagicKeyboard extends StatefulWidget {
  @override
  MagicKeyboardState createState() => MagicKeyboardState();
}

class MagicKeyboardState extends State<MagicKeyboard> {

  final List<String> buttons = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "Next"];
  final void Function()? onNextPressed = null;

  double _capturedInput = 0;
  double get capturedInput => _capturedInput;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      // Take each button item in the list and convert it to an individual button widget
      children: buttons.map(
        (e) => generateKeyTile(e)).toList(growable: false
      ),
    );
  }

  Widget generateKeyTile(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          processKeyInput(label);
          SystemSound.play(SystemSoundType.click);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[600]!.withOpacity(0.1)),
          surfaceTintColor: WidgetStatePropertyAll(Colors.grey[700]!.withOpacity(0.1)),
          overlayColor: WidgetStatePropertyAll(Colors.grey[700]!.withOpacity(0.15)),
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
    );
  }

  void processKeyInput(String label) {

  }
}