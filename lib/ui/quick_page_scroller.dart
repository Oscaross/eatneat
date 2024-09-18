// Widget to render the { ... } buttons that the user can use to quickly move between pages rather than endlessly having to scroll horizontally

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickPageScroller extends StatefulWidget {
  final int totalElements;
  final int currentPageIndex;
  final int elementsPerPage;
  final ScrollController controller;
  final double pageSize;
  final void Function()? onWidgetTap;

  QuickPageScroller({required this.totalElements, required this.currentPageIndex, required this.elementsPerPage, required this.controller, required this.pageSize, this.onWidgetTap});

  @override
  QuickPageScrollerState createState() => QuickPageScrollerState();
}

class QuickPageScrollerState extends State<QuickPageScroller> {

  int _currentPageIndex = 0;
  int _totalPages = 0;
  bool _isActive = false;
  bool _showWidget = false;
  double _pageSize = 0;
  void Function()? onWidgetTap;
  ScrollController _controller = ScrollController(); // init to blank to stop compiler complaining

  double _distanceToAdvance = 0;
  double _oldDX = 0;

  @override
  void initState() {
    onWidgetTap = widget.onWidgetTap;

    _controller = widget.controller;
    _pageSize = widget.pageSize;

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
              bool updateNegative = _currentPageIndex > 0;
              bool updatePositive = _currentPageIndex < _totalPages - 1;

              if(dxMoved.isNegative) {
                _currentPageIndex += (updateNegative) ? -1 : 0;
              }
              else {
                _currentPageIndex += (updatePositive) ? 1 : 0;
              }

              if(updateNegative && updatePositive) updatePage();
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
                itemBuilder: (_, index) => drawPageIcon(index)
              ),
            ),
              ),
        )
      ),
    );
  }

  Widget drawPageIcon(int index) {
    // The difference of the current page from the page we want a dot for
    int indexDiff = (_currentPageIndex - index).abs();

    // If we are more than 2 pages out from where we are, don't bother rendering a dot for this page
    if(indexDiff > 2) return Center();

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Icon(
        Icons.circle,
        // Make the dot bigger based on how close it is to the selected page
        size: (indexDiff == 2) ? 7 : 9,
        color: (index == _currentPageIndex) ? ((_isActive) ? Colors.grey.shade800 : Colors.grey.shade700) : Colors.grey.shade400,
      ),
    );
  }

  void updatePage() {
    _controller.animateTo(_pageSize * _currentPageIndex, duration: const Duration(milliseconds: 50), curve: Curves.elasticIn);
    HapticFeedback.selectionClick();
  }
}