import 'package:flutter/material.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PantryProvider>(context, listen:false);

    return Row(
      children: [
        Flexible(
          flex: 4,
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                  onSubmitted: (input) {
                    controller.clearComposing();
                  },
                  onChanged: (input) {
                    provider.searchBy(input.toLowerCase());
                  },
                  controller: controller,
                  hintText: "Search my pantry...",
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  elevation: WidgetStatePropertyAll(2),
                  trailing: [
                     IconButton(
                      onPressed: () {
                        provider.searchBy("");
                        controller.clear();
                        // Remove the keyboard
                        controller.clearComposing();
                        // Stop searching
                        provider.stopSearching();
                      }, 
    
                      icon: Icon(Icons.close)),
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