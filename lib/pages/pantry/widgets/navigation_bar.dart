import 'package:flutter/material.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  var _selectedSortByMode = SortByMode.alphabetical;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PantryProvider>(context, listen:false);
    var searchResult = provider.items;

    return Row(
      children: [
        Flexible(
          flex: 4,
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                  onSubmitted: (input) {
                    
                  },
                  onChanged: (input) {
                    searchResult = provider.searchBy(input);
                  },
                  controller: controller,
                  hintText: "Search",
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  elevation: WidgetStatePropertyAll(2),
                  trailing: [
                    DropdownButton(
                      icon: Icon(Icons.sort),
                      elevation: 1,
                      value: _selectedSortByMode,
                      items: [
                        DropdownMenuItem(
                          value: SortByMode.alphabetical,
                          child: Text("Alphabetical"),
                        ),
                        DropdownMenuItem(
                          value: SortByMode.expiryDate,
                          child: Text("Expiry")
                        ),
                        DropdownMenuItem(
                          value: SortByMode.dateAdded,
                          child: Text("Date added")
                        ),
                        DropdownMenuItem(
                          value: SortByMode.weight,
                          child: Text("Weight")
                        ),
                      ],
                    
                      onChanged: (value) {
                        setState(() {
                          _selectedSortByMode = value!;
                          provider.sortBy(_selectedSortByMode);
                        });
                      }
                    
                    ),
                  ],
                );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            },
          ),
        ),
      ],
    );
  }
}