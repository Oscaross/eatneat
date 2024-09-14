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
  bool _isActive = false;
  bool _showWidget = false;
  void Function()? onWidgetTap;

  int _pagesMoved = 0;
  double _distanceToAdvance = 0;
  double _oldDX = 0;

  @override
  void initState() {
    onWidgetTap = widget.onWidgetTap;

    // What page is the user currently viewing, how many pages are there in total (divide by the total viewable in each page then ceiling)
    _currentPageIndex = widget.currentPageIndex;
    _totalPages = (widget.totalElements / widget.elementsPerPage).ceil();
    // TODO: Fix the fact that the search bar doesn't correctly reflect this boolean property (if you search and have 1 item in a view, it still thinks we need to show the widget)
    _showWidget = (_totalPages > 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If this property is false it means we have one page or fewer, that would mean it is pointless to display this widget so instead return nothing
    if(!_showWidget) return Center();

    // Set the distance required to move the page counter by 1 
    _distanceToAdvance = MediaQuery.of(context).size.width * 0.04;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        // If we're long-pressing the widget then we need to be able to swipe left or right to move between pages
        onLongPress: () {
          setState(() {
            _isActive = true;
          });

          HapticFeedback.selectionClick();
        },

        onLongPressMoveUpdate: (details) {
          double dx = details.offsetFromOrigin.dx;
          double dxMoved = (dx - _oldDX);

          if(dxMoved.abs() > _distanceToAdvance) {

            setState(() {
              if(dxMoved.isNegative) {
                _currentPageIndex += (_currentPageIndex > 0) ? -1 : 0;
              }
              else {
                _currentPageIndex += (_currentPageIndex < _totalPages - 1) ? 1 : 0;
              }
              HapticFeedback.selectionClick();
            });

            _oldDX = dx;
          }
        },

        onLongPressEnd: (_) {
          setState(() {
            _isActive = false;
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
                  return drawPageIcon(index);
                  
                },
              ),
            ),
              ),
        )
      ),
    );
  }

  Widget drawPageIcon(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Icon(
        Icons.circle,
        size: 8,
        color: (index == _currentPageIndex) ? Colors.grey.shade700 : Colors.grey.shade400,
      ),
    );
  }

  Widget drawSmallPageIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 1),
      child: Icon(
        Icons.circle,
        size: 6,
        color: Colors.grey.shade400,
      ),
    );

  }
}