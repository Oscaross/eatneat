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

  ItemViewPage({this.item});

  @override
  ItemViewPageState createState() => ItemViewPageState();
}

class ItemViewPageState extends State<ItemViewPage> {

  PantryItem? item;

  String name = "";

  // Controllers - contain final values to push to the pantry item after the user hits the submit action.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  PantryCategory? _category;
  double _currentPercentageLeft = 100;

  // Focus nodes (helps us decide when we are editing fields and when we aren't)
  // IMPORTANT: here are the mappings from integer to node
  // 0 => item name, 1 => quantity, 2 => weight, 3 => expiry date

  // A numerical system that sets up a focus node for each editable UI widget 
  final Map<int, FocusNode> _focusNodeMap = {};
  // Numerical system to capture the state of each node
  final Map<int, bool> _focusStateMap = {};
  

  late Color _sliderColor;

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

    // Initialise focus nodes - 4 in total to instantiate because there are 5 fields
    for(int i = 0; i < 4; i++) {
      _focusNodeMap[i] = FocusNode(debugLabel: "Addition page focus node index $i");
      _focusNodeMap[i]!.addListener(() {
        setState(() {
          _focusStateMap[i] = _focusNodeMap[i]!.hasFocus;
        });
      });
    }

    // Configure values to the current known item state
    if(item != null) {
      _nameController.text = item!.name;
      // TODO: Figure out how to autofill expiry, quantity and weight fields using their controllers
      _category = item!.category;
    }
    
    _sliderColor = getSliderColor(_currentPercentageLeft);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // Stops the UI from shrinking and breaking when the keyboard is pulled up
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Item"),
      ),
      body:
        // The entire body is wrapped with a Flex widget. This means we can dynamically size this UI based on the device 
        // We also wrap the body with a gesture detector and this is to allow the keyboard to be focused/unfocused when the user taps outside of its focus box
        GestureDetector(
          onTap: () {
            // We're attempting to escape keyboard input so unfocus to show the whole page again!
            setState(() {
              _focusNodeMap.forEach((_, node) => node.unfocus(),);
            });
          },
          child: Column(
            children: [
              Spacer(flex: 1),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name, 
                        focusNode: _focusNodeMap[0],
                        decoration: InputDecoration(
                          hintText: "Enter product name...",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
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
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: GestureDetector(
                      onTap: () => _showCategoryPicker(context), // Opens the picker
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
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
          
                Spacer(flex: 1),
                // Widget to display product image
          
                Flexible(
                  flex: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0), // Adjust the value for roundness
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
                Spacer(flex: 1),
          
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
                            fontWeight: (_focusStateMap[1] ?? false) ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 16,
                          )
                        ),
                      ),
                      Spacer(flex: 2),
                      Text(
                        "Weight",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: (_focusStateMap[2] ?? false) ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 16,
                        )
                      ),
                      Spacer(flex: 4),
                      Text(
                        "Expiry Date",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: (_focusStateMap[3] ?? false) ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 16,
                        )
                      ),
                      Spacer(flex: 5),
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
                        flex: 1,
                        child: generateInputField(TextInputType.none, _quantityController, 1),
                      ),
                      // Weight controller (what is the weight of each unit)
                      Flexible(
                        flex: 2,
                        child: generateInputField(TextInputType.none, _weightController, 2),
                      ),
                      // Expiry controller (when will the item expire)
                      Flexible(
                        flex: 3,
                        child: generateInputField(TextInputType.datetime, _expiryController, 3),
                      ),
                    ]
                  ),
                ),
          
                // Widget to display % left slider
                Spacer(flex: 1),
          
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
                Spacer(flex: 2),
                Flexible(
                  flex: 2,
                  child: TextButton.icon(
                    label: Text("Add Item", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 16)),
                    icon: Icon(Icons.add, color: Colors.blueAccent),
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
                      fixedSize: WidgetStatePropertyAll(Size(400, 40)),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.15)),
                      overlayColor: WidgetStatePropertyAll(Colors.blueAccent.withOpacity(0.05)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                    )
                  ),
                ),
                Spacer(flex: 1),
            ]
          ),
        ),
    );
  }

  Color getSliderColor(double percentage) {
    if(percentage > 50) {
      return Color.fromARGB(255, 43, 225, 137);
    }
    else if(percentage >= 30) {
      return Color.fromARGB(255, 251, 233, 73);
    }
    else {
      return Colors.red;
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

  Widget generateInputField(TextInputType keyboardType, TextEditingController controller, int focusIndex) {
    bool isFocused = _focusStateMap[focusIndex] ?? false;

    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0), 
          border: Border.all(
            color: (isFocused) ? Colors.blueAccent : Colors.grey[300]!,
            width: (isFocused) ? 2 : 1.5,
          )
        ),
        child: TextField(
          focusNode: _focusNodeMap[focusIndex],
          controller: controller,
          keyboardType: keyboardType,
          onTap: () {
            print("Trying to spawn keyboard");
            setState(() {
              spawnMagicKeyboard();
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none, 
            contentPadding: EdgeInsets.symmetric(horizontal: 12), 
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // A beautiful, animated sequence that will eventually result in our magic keyboard rising from the ashes... Hopefully
  Widget spawnMagicKeyboard() {
    return MagicKeyboard();
  }
}