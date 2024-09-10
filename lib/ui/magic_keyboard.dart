import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Represents a numerical keypad that allows for quick, efficient and seemless modification of values such as quantity or weight

class MagicKeyboard extends StatefulWidget {
  final void Function(String val) onChanged;
  final void Function()? onKeyboardDown;
  final int? maxStringLength;
  final int step;
  // Capture the current value held within the box if there is one.
  final String? currentValue;

  MagicKeyboard({required this.onChanged, required this.step, this.onKeyboardDown, this.maxStringLength, this.currentValue});

  @override
  MagicKeyboardState createState() => MagicKeyboardState();
}

class MagicKeyboardState extends State<MagicKeyboard> {

  final List<String> buttons = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "Clr", ".", "0", "x", "Down"];
  void Function()? onKeyboardDown;
  int maxStringLength = 10;
  int step = 0;

  String _capturedInput = "";
  String get capturedInput => _capturedInput;

  // Can't let the user have more than one decimal point!
  bool _hasDecimalPoint = false;

  @override
  void initState() {
    onKeyboardDown = widget.onKeyboardDown;
    maxStringLength = widget.maxStringLength ?? 10;
    step = widget.step;
    _capturedInput = widget.currentValue ?? "";

    super.initState();
  }

  // TODO: Make it so the user can collapse the magic keyboard
  // TODO: Improve the animation for when the magic keyboard comes onto the screen

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      crossAxisCount: 4,
      // Take each button item in the list and convert it to an individual button widget
      children: buttons.map((e) => generateKeyTile(e)).toList(growable: false),
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
              case "Down":
                (onKeyboardDown == null) ? null : onKeyboardDown!();
              case "Clr":
                processClear();
              case ".":
                processDecimal();
              case "x":
                processBackspace();
              case "+":
              case "-":
                processStep(label);
              default:
                processNumericalInput(label);
            }

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
            child: generateButtonChild(label),
          ),
        ),
      ),
    );
  }

  // Enables us to display both icons such as the clear or next icon as well as appropriately sized text for the other ones
  Widget generateButtonChild(String label) {
    switch(label) {
      case "x":
        return Icon(
            Icons.backspace,
            weight: 20,
            size: 24,
            color: Colors.blue,
          );
      case "+":
        return Icon(
            Icons.add,
            weight: 20,
            size: 30,
            color: Colors.blue,
          );
      case "-":
        return Icon(
            Icons.remove,
            weight: 20,
            size: 30,
            color: Colors.blue,
          );
      case "Down":
        return Icon(
            Icons.keyboard_double_arrow_down,
            weight: 20,
            size: 30,
            color: Colors.blue,
          );
      case "Clr":
        return Text(
          label,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        );
      default:
        return Text(
          label,
          style: TextStyle(
            color:Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w800
          )
        );
    }
  }

  void processNumericalInput(String label) {
    // We can't have a leading zero
    if(label == "0" && _capturedInput == "") return;

    _capturedInput = _capturedInput + label;
    
    if(_capturedInput.length <= maxStringLength) widget.onChanged(capturedInput);
  }

  void processBackspace() {
    if(_capturedInput == "") return;

    // If we're about to delete a decimal point we need to reflect this by saying we no longer have a decimal point, otherwise the user will be unable to type another one
    if(_capturedInput[_capturedInput.length - 1] == ".") _hasDecimalPoint = false;

    _capturedInput = _capturedInput.substring(0, _capturedInput.length - 1);
    widget.onChanged(_capturedInput);
  }

  void processStep(String action) {
    double val = double.tryParse(_capturedInput) ?? 0;

    bool adding = (action == "+");

    val = val + ((adding) ? step : -step);
    // Can't have negative weight, if val is negative clamp it at 0
    if(val < 0) val = 0;

    // Convert the value to a string with up to 2 decimal places
    String formattedVal = val.toStringAsFixed(2);
    
    // Remove trailing '.0' if there are no decimal digits - keeps only significant figures in the decimal places
    if (formattedVal.endsWith('.00')) {
      formattedVal = formattedVal.substring(0, formattedVal.length - 3);
    } else if (formattedVal.endsWith('0')) {
      formattedVal = formattedVal.substring(0, formattedVal.length - 1);
    }

    _capturedInput = formattedVal;
    widget.onChanged(_capturedInput);
    HapticFeedback.lightImpact();
  }
 
  void processDecimal() {
    // Check whether it makes sense to type a decimal, if any of these are true we need to get out of handling this
    if ((_hasDecimalPoint) || (_capturedInput.length >= maxStringLength - 1) || (_capturedInput == "")) return;

    _hasDecimalPoint = true;
    processNumericalInput(".");
  }

  void processClear() {
    if(_capturedInput.contains(".")) _hasDecimalPoint = false;

    HapticFeedback.mediumImpact();

    _capturedInput = "";
    widget.onChanged(_capturedInput);
  }
}