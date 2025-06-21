import 'package:flutter/material.dart';

import 'insert_grades_page.dart';
import 'grades_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;


  final List<Widget> _pages = [
    const InsertGradesPage(),
    const SafeGradesListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // الصفحة الحالية
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // تغيير الصفحة عند الضغط
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
