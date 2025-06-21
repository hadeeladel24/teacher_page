import 'package:flutter/material.dart';

import 'Insert_grades_page.dart';
import 'Show_grades_page.dart';

class HomePage extends StatefulWidget {
  final String teacherId;
  const HomePage({super.key, required this.teacherId});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      InsertGradesPage(teacherId: widget.teacherId),
      SafeGradesListPage(teacherId: widget.teacherId),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Insert Grades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Grades',
          ),
        ],
      ),
    );
  }
}


