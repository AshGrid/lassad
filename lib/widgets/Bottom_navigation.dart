import 'package:flutter/material.dart';


class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white, // Optional, for item background color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Courses',
            backgroundColor: Colors.white, // Optional, for item background color
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.white, // Optional, for item background color
          ),

        ],
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.blue, // Make background transparent to use Container color
        selectedItemColor: Colors.white, // Set color for selected item
        unselectedItemColor: Colors.white54, // Set color for unselected items

      );
  }
}
