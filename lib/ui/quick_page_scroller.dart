// Widget to render the { ... } buttons that the user can use to quickly move between pages rather than endlessly having to scroll horizontally

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickPageScroller extends StatefulWidget {
  final int totalElements;
  final int currentPageIndex;
  final int elementsPerPage;
  final void Function()? onWidgetTap;

  QuickPageScroller({required this.totalElements, required this.currentPageIndex, required this.elementsPerPage, this.onWidgetTap});

  @override
  QuickPageScrollerState createState() => QuickPageScrollerState();
}

class QuickPageScrollerState extends State<QuickPageScroller> {

  int _currentPageIndex = 0;
  int _totalPages = 0;
  bool _isSwipingBetweenPages = false;
  bool _showWidget = false;
  void Function()? onWidgetTap;

  @override
  void initState() {
    onWidgetTap = widget.onWidgetTap;

    // What page is the user currently viewing, how many pages are there in total (divide by the total viewable in each page then ceiling)
    _currentPageIndex = widget.currentPageIndex;
    _totalPages = (widget.totalElements / widget.elementsPerPage).ceil();
    _showWidget = (_totalPages > 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If this property is false it means we have one page or fewer, that would mean it is pointless to display this widget so instead return nothing
    if(!_showWidget) return Center();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        // If we're long-pressing the widget then we need to be able to swipe left or right to move between pages
        onLongPress: () {
          setState(() {
            _isSwipingBetweenPages = true;
          });

          HapticFeedback.selectionClick();
        },

        onLongPressEnd: (_) {
          setState(() {
            _isSwipingBetweenPages = false;
          });
        },
      
        onTap: () {
          // If we tap the whole widget then do some custom logic, for example, navigate to the search bar so the user can search for what they are looking for
          if(onWidgetTap != null) {
            onWidgetTap!();
            HapticFeedback.lightImpact();
          }
        },
      
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
            width: MediaQuery.of(context).size.width * 0.13,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: max(0, _totalPages),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: (index == _currentPageIndex) ? Colors.grey[700] : Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
              ),
        )
      ),
    );
  }
}