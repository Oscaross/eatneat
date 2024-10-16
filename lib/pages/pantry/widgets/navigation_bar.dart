import 'package:eatneat/models/pantry/pantry_item.dart';
import 'package:eatneat/pages/pantry/item_view_page.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  final void Function(String input) onChanged;
  final void Function(String input) onSubmitted;

  Navbar({required this.onChanged, required this.onSubmitted});

  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {

  // Search bar logic is custom and dependent on the widget that requested it so we should delegate this to the caller
  late void Function(String input) onChanged;
  late void Function(String input) onSubmitted;

  @override
  void initState() {
    onChanged = widget.onChanged;
    onSubmitted = widget.onSubmitted;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                  onTap: () {
                    controller.openView();
                  },
                  onSubmitted: (input) {
                    onSubmitted(input);
                    controller.clearComposing();
                  },
                  onChanged: (input) {
                    onChanged(input);
                  },
                  controller: controller,
                  hintStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyLarge),
                  hintText: "Search my pantry...",
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  elevation: WidgetStatePropertyAll(2),
                  trailing: [
                     IconButton(
                      onPressed: () {
                        controller.clear();
                        controller.clearComposing();

                        onChanged("");
                      }, 
    
                      icon: Icon(Icons.close)),
                  ],
                );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) => generateSearchCandidates(context, controller),
          ),
        ),
      ],
    );
  }

  List<ListTile> generateSearchCandidates(BuildContext context, SearchController controller) {
    // Get the search result candidates by scanning the entire pantry (regardless of categories)
    List<PantryItem> results = Provider.of<PantryProvider>(context, listen:false).searchByTerm(controller.text);

    return List.generate(
      results.length,
      (index) {
        return ListTile(
          title: Text(results[index].name),
          // When we press the ListTile, navigate to the item's view page
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder:(context) => ItemViewPage(actionType: ActionType.edit, item: results[index]),)
            );
          }
        );
      }
    );
  }
}