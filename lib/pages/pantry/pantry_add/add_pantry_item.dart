import 'package:eatneat/models/label_item.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// TODO: This UI relies heavily on inconsistent static pixel based harcodings! We must implement MediaQuery.of to ensure consistent styling across devices.

class AddItemPage extends StatefulWidget {
  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {

  PantryItem? item;

  AddItemPageState({this.item}) {
    // Configure values to the current known item state
    if(item != null) {
      _nameController.text = item!.name;
      // TODO: Figure out how to autofill expiry, quantity and weight fields using their controllers
      _category = item!.category;
    }
    
    _sliderColor = getSliderColor(_currentPercentageLeft);

  }

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
    // Initialise focus nodes - 4 in total to instantiate because there are 5 fields
    for(int i = 0; i < 4; i++) {
      _focusNodeMap[i] = FocusNode(debugLabel: "Addition page focus node index $i");
      _focusNodeMap[i]!.addListener(() {
        setState(() {
          _focusStateMap[i] = _focusNodeMap[i]!.hasFocus;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item"),
      ),
      body:
        Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: TextField(
                    controller: _nameController,
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
              // Widget to display product categories
              Padding(
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
                        SizedBox(width: 10),
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

              SizedBox(height: 10),
              // Widget to display product image

              Container(
                height: 300.0,
                width: 400.0,
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
              SizedBox(height: 10),

              // Widget to display quantity editor
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Quantity controller (how many units we have)
                  Flexible(
                    flex: 1,
                    child: generateInputField(TextInputType.number, _quantityController, 1),
                  ),
                  // Weight controller (what is the weight of each unit)
                  Flexible(
                    flex: 2,
                    child: generateInputField(TextInputType.number, _weightController, 2),
                  ),
                  // Expiry controller (when will the item expire)
                  Flexible(
                    flex: 3,
                    child: generateInputField(TextInputType.datetime, _expiryController, 3),
                  ),
                ]
              ),

              // Widget to display % left slider
              SizedBox(height: 10),

              Card(
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

              // The slider itself that we control the quantity with
              Slider(
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
              // Quick action buttons to go to empty, half full and full
              Row(
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
              SizedBox(height: 20),
              TextButton.icon(
                label: Text("Add Item", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 16)),
                icon: Icon(Icons.add, color: Colors.blueAccent),
                onPressed: () {
                  print("Adding to pantry");
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
              )
          ]
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
          decoration: InputDecoration(
            border: InputBorder.none, 
            contentPadding: EdgeInsets.symmetric(horizontal: 12), 
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}