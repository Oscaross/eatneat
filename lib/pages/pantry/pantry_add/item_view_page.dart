import 'package:eatneat/models/label_item.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:eatneat/ui/magic_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemViewPage extends StatefulWidget {
  final PantryItem? item;
  final ActionType actionType;

  ItemViewPage({this.item, required this.actionType});

  @override
  ItemViewPageState createState() => ItemViewPageState();
}

class ItemViewPageState extends State<ItemViewPage> {

  PantryItem? item;
  late ActionType actionType;

  String name = "";

  // Controllers - contain final values to push to the pantry item after the user hits the submit action.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  bool _isMagicKeyboardShowing = false;
  double _keyboardBottomPosition = -300;
  PantryCategory? _category;
  double _currentPercentageLeft = 100;

  // A numerical system that sets up a focus node for each editable UI widget 
  final Map<FocusableWidget, FocusNode> _focusNodeMap = {};
  // Numerical system to capture the state of each node
  final Map<FocusableWidget, bool> _focusStateMap = {};
  // The current focused node, none initially and none if we aren't looking at any nodes right now
  FocusableWidget _focus = FocusableWidget.none;
  
  // Color theme related variables
  late Color _sliderColor;
  static final Color containerGrey = Colors.grey[100]!;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _expiryController.dispose();
    _focusNodeMap.forEach((_, focusNode) => focusNode.dispose(),);
    
    super.dispose();
  }

  @override
  void initState() {
    item = widget.item;
    actionType = widget.actionType;

    // Initialise focus nodes - 4 in total to instantiate because there are 5 fields
    for(FocusableWidget cf in FocusableWidget.values) {
      _focusNodeMap[cf] = FocusNode(debugLabel: "Addition page focus node index $cf");
      _focusNodeMap[cf]!.addListener(() {
        setState(() {
          _focusStateMap[cf] = _focusNodeMap[cf]!.hasFocus;
        });
      });
    }

    // Configure values to the current known item state
    if(item != null) {
      _nameController.text = item!.name;
      _quantityController.value = TextEditingValue(text: item!.quantity.toString());
      _weightController.value = TextEditingValue(text: item!.weight.toString());
      _expiryController.value = TextEditingValue(text:formatSelectedExpiry(item!.expiry));
      _category = item!.category;
    }
    
    _sliderColor = getSliderColor(_currentPercentageLeft);

    super.initState();
  }

  void unfocus(FocusableWidget focus) {
    setState(() {
      _focusStateMap[focus] = false;
      _focus = FocusableWidget.none;
      magicKeyboardDown();
    });
  }

  void magicKeyboardUp() {
    setState(() {
      _isMagicKeyboardShowing = true;
      _keyboardBottomPosition = 0;
    });
  }

  void magicKeyboardDown() {
    setState(() {
      _isMagicKeyboardShowing = false;
      _keyboardBottomPosition = -300;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
        // Stops the UI from shrinking and breaking when the keyboard is pulled up
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(actionType == ActionType.add ? "Add Item" : "View Item"),
        ),
        body:
          // The entire body is wrapped with a Flex widget. This means we can dynamically size this UI based on the device 
          // We also wrap the body with a gesture detector and this is to allow the keyboard to be focused/unfocused when the user taps outside of its focus box
          GestureDetector(
            onTap: () {
              // We're attempting to escape keyboard input so unfocus to show the whole page again!
              unfocus(_focus);
            },
            child: Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                    child: TextField(
                        onTap: () {
                          // Can't have two keyboards at once!
                          if(_isMagicKeyboardShowing) magicKeyboardDown();
                        },
                        controller: _nameController,
                        keyboardType: TextInputType.name, 
                        focusNode: _focusNodeMap[0],
                        decoration: InputDecoration(
                          hintText: "Enter product name...",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: containerGrey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          prefixIcon: Icon(Icons.label, color: Colors.grey[600]),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ),
                  // Widget to display product categories
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          if(_isMagicKeyboardShowing) magicKeyboardDown();
                          _showCategoryPicker(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: containerGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.category, color: Colors.blue),
                              SizedBox(width: deviceSize.width / 34),
                              Expanded(
                                child: Text(
                                  (_category == null) ? "Pick a category..." : _category!.name, // Display the selected category
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: (_category == null) ? FontWeight.normal : FontWeight.w600,
                                    color: _category == null ? Colors.grey[400] : Colors.blue,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 30,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: deviceSize.height * 0.006),
            
                  // Widget to display quantity editor
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            "Qty",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: (_focusStateMap[FocusableWidget.quantity] ?? false) ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 16,
                            )
                          ),
                        ),
                        Spacer(flex: 5),
                        Text(
                          "Grams",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: (_focusStateMap[FocusableWidget.weight] ?? false) ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 16,
                          )
                        ),
                        Spacer(flex: 9),
                        Text(
                          "Expiry Date",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: (_focusStateMap[FocusableWidget.expiry] ?? false) ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 16,
                          )
                        ),
                        Spacer(flex: 8),
                      ]
                    )
                  ),
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Quantity controller (how many units we have)
                        Flexible(
                          flex: 2,
                          child: generateInputField(_quantityController, FocusableWidget.quantity),
                        ),
                        // Weight controller (what is the weight of each unit)
                        Flexible(
                          flex: 4,
                          child: generateInputField(_weightController, FocusableWidget.weight),
                        ),
                        // Expiry controller (when will the item expire)
                        Flexible(
                          flex: 5,
                          child: generateInputField(_expiryController, FocusableWidget.expiry),
                        ),
                      ]
                    ),
                  ),
            
                  SizedBox(height: deviceSize.height * 0.006),
                  // Widget to display product image
            
                  Flexible(
                    flex: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: containerGrey,
                        borderRadius: BorderRadius.circular(12.0), 
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0), // Same value to clip the image
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  // The default image or an image which exists if it does
                                  (item == null || item!.image == null)
                                      ? "https://assets.sainsburys-groceries.co.uk/gol/7931400/1/640x640.jpg"
                                      : item!.image!,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            
                  // Widget to display % left slider
                  SizedBox(height: deviceSize.height * 0.01),
            
                  Flexible(
                    flex: 3,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[500]!,
                          width: 1.5, 
                        ),
                        borderRadius: BorderRadius.circular(10.0), 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), 
                        child: Text(
                          "${_currentPercentageLeft.toInt()}% left",
                          style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
            
                  // The slider itself that we control the quantity with
                  Flexible(
                    flex: 2,
                    child: Slider(
                      value: _currentPercentageLeft,
                      max: 100,
                      min: 0,
                      divisions: 20,
                      activeColor: _sliderColor,
                      inactiveColor: _sliderColor.withOpacity(0.2),
                      onChanged: (val) {
                        setState(() {
                          _currentPercentageLeft = val;
                          _sliderColor = getSliderColor(val);
                        });
                            
                        HapticFeedback.selectionClick();
                      }
                    ),
                  ),
                  // Quick action buttons to go to empty, half full and full
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: percentLeftButtonStyle(),
                          onPressed: () {
                            setState(() {
                              _currentPercentageLeft = 0;
                              _sliderColor = getSliderColor(0);
                            });
                            
                            HapticFeedback.lightImpact();
                          },
                          child: Text("Empty")
                        ),
                        TextButton(
                          style: percentLeftButtonStyle(),
                          onPressed: () {
                            setState(() {
                              _currentPercentageLeft = 50;
                              _sliderColor = getSliderColor(50);
                            });
                            
                            HapticFeedback.lightImpact();
                          },
                          child: Text("Half")
                        ),
                        TextButton(
                          style: percentLeftButtonStyle(),
                          onPressed: () {
                            setState(() {
                              _currentPercentageLeft = 100;
                              _sliderColor = getSliderColor(100);
                            });
                            
                            HapticFeedback.lightImpact();
                          },
                          child: Text("Full")
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceSize.height * 0.03),
                  Flexible(
                    flex: 2,
                    child: TextButton.icon(
                      label: Text((actionType == ActionType.add) ? "Add Item" : "Save Changes", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 16)),
                      icon: Icon((actionType == ActionType.add) ? Icons.add : Icons.check, color: Colors.blueAccent),
                      onPressed: () {
                        // TODO: Make parsing and logic checks here more robust & test them for weaknesses
                        String name = _nameController.value.text;
                        double weight = double.tryParse(_weightController.value.text) ?? 0;
                        int quantity = int.tryParse(_quantityController.value.text) ?? 1;
                        DateTime added = DateTime.now();
                        // TODO: Should we allow no category? For now I will but not sure
                        PantryCategory category = _category ?? PantryCategory.none;
                        // TODO: not even gonna bother with this shit tonight
                        DateTime expiry = DateTime.now();
                        Set<LabelItem> labelSet = {};
                            
                        if(item == null) {
                            
                          PantryItem i = PantryItem(
                            name: name,
                            weight: weight,
                            quantity: quantity,
                            added: added,
                            expiry: expiry,
                            labelSet: labelSet
                          );
                          
                          Provider.of<PantryProvider>(context, listen:false).addItem(i);
                          // TODO: Terrible addition logic, it should be set in the pantry item constructor and handled independent of these classes as that's asking for trouble
                          category.addToCategory(i);
                        }
                        else {
                          item!.name = name;
                          item!.weight = weight;
                          item!.quantity = quantity;
                          item!.added = added;
                          item!.category = category;
                          item!.expiry = expiry;
                          item!.labelSet = labelSet;
                            
                          category.addToCategory(item!);
                        }
                            
                        HapticFeedback.heavyImpact();
                        Navigator.pop(context);
                      },
                            
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.95, MediaQuery.of(context).size.height * 0.14)),
                        backgroundColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.15)),
                        overlayColor: WidgetStatePropertyAll(Colors.blueAccent.withOpacity(0.05)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                      )
                    ),
                  ),
                  SizedBox(height: deviceSize.height * 0.01),
                  Flexible(
                    flex: 2,
                    child: TextButton.icon(
                      label: Text((actionType == ActionType.add) ? "Cancel" : "Delete Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      icon: Icon((actionType == ActionType.add) ? Icons.delete : Icons.cancel, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        
                        // TODO: Show a confirmation alert dialog
                        
                      },
                            
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.95, MediaQuery.of(context).size.height * 0.1)),
                        backgroundColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.7)),
                        overlayColor: WidgetStatePropertyAll(Colors.redAccent.withOpacity(0.7)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
                      )
                    ),
                  ),
                ]
              ),
            ),
        ),
        if (_isMagicKeyboardShowing)
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          curve: Curves.easeIn,
          height: deviceSize.height * 0.52,
          bottom: _keyboardBottomPosition,
          left: 0,
          right: 0,
          child: MagicKeyboard(
            step: (_focus == FocusableWidget.quantity) ? 1 : 100,
            maxStringLength: 8,
            onChanged: (String val) {           
              switch (_focus) {
                case FocusableWidget.weight:
                  _weightController.value = TextEditingValue(text: val);
                case FocusableWidget.quantity:
                  _quantityController.value = TextEditingValue(text: val);
                case _:

              }
            },
            onNextPressed: () {
              // TODO: Fetch the next input node and focus it instead
             
            },
          ),
        ),
      ]
    );
  }

  Color getSliderColor(double percentage) {
    if(percentage > 50) {
      return Color.fromARGB(255, 43, 225, 137);
    }
    else if(percentage >= 30) {
      return Colors.yellow[600]!;
    }
    else {
      return Colors.red[600]!;
    }
  }

  void _showCategoryPicker(BuildContext context) {
    List<PantryCategory> categories = Provider.of<PantryProvider>(listen:false, context).categories;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _category = categories[index];
              });
            },
            children: categories.map((PantryCategory category) {
              return Center(child: Text(category.name));
            }).toList(),
          ),
        );
      },
    );
  }

  static ButtonStyle percentLeftButtonStyle() {
    return ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.blueAccent),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.blueAccent,
        ),
      ),
      side: WidgetStatePropertyAll(BorderSide(color: Colors.blueAccent, width: 2)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      overlayColor: WidgetStatePropertyAll(
        Colors.blueAccent.withOpacity(0.1),
      ),
    );
  }

  Widget generateInputField(TextEditingController controller, FocusableWidget widget) {
    bool isFocused = _focusStateMap[widget] ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4), 
      child: Container(
        decoration: BoxDecoration(
          color: containerGrey,
          borderRadius: BorderRadius.circular(12.0), 
          border: Border.all(
            color: (isFocused) ? Colors.blueAccent : Colors.grey[300]!,
            width: (isFocused) ? 2 : 1.5,
          )
        ),
        child: TextField(
          focusNode: _focusNodeMap[widget],
          showCursor: (widget != FocusableWidget.expiry) && (_focus == widget), // unless it's the date picker we need a cursor
          controller: controller,
          keyboardType: TextInputType.none, // we use custom inputs for all of our fields in this row, no need for a keyboard type
          onTap: () async {
            if(_focus == widget) return; // if we are already focused on this widget - escape before we mess up the object state!

            _focus = widget;
            // Display a magic keyboard for numerical input
            if (widget == FocusableWidget.quantity || widget == FocusableWidget.weight) {
              setState(() {
                magicKeyboardUp();
              });
            // Display a flutter DatePicker for the expiry date
            } else if (widget == FocusableWidget.expiry) {
              final selectedDate = await showDatePicker(
                fieldLabelText: "Choose expiry date",
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)), 
                lastDate: DateTime.now().add(const Duration(days: 10000)),
              );

              setState(() {
                controller.text = formatSelectedExpiry(selectedDate);
              });
            } 
            else {
              throw ArgumentError("Controller requested a keyboard that does not exist!");
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none, 
            contentPadding: EdgeInsets.symmetric(horizontal: 12), 
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isFocused ? Colors.grey[800] : Colors.grey[700],
          )
        ),
      ),
    );
  }

  String formatSelectedExpiry(DateTime? selectedExpiry) {
    if(selectedExpiry == null) return "Choose expiry...";

    var month = selectedExpiry.month;
    var trunc = "";

    switch(month) {
      case 1:
      trunc = "Jan";
      case 2:
      trunc = "Feb";
      case 3:
      trunc = "Mar";
      case 4:
      trunc = "Apr";
      case 5:
      trunc = "May";
      case 6:
      trunc = "Jun";
      case 7:
      trunc = "Jul";
      case 8:
      trunc = "Aug";
      case 9:
      trunc = "Sep";
      case 10:
      trunc = "Oct";
      case 11:
      trunc = "Nov";
      case 12:
      trunc = "Dec";
    }

    // The number of days from now until when the product is set to expire
    var daysUntil = selectedExpiry.difference(DateTime.now()).inDays;

    // If there are more than 365 days until the product expires it should also show the year it will expire in
    return (daysUntil >= 365 || daysUntil < 0) ? "$trunc ${selectedExpiry.day} ${selectedExpiry.year}" : "$trunc ${selectedExpiry.day}";
  }
}

// Allows us to keep track of which editable widget is currently in focus for the user
enum FocusableWidget {
  quantity,
  weight,
  name,
  expiry,
  category,
  none
}

// Allows us to render the viewer page accordingly based off of whether we're adding this item for the first time or we are just editing something
// ie. if we click an existing item, the 'Add Item' button should instead be displayed as a "Save Changes" button
enum ActionType {
  edit,
  add
}