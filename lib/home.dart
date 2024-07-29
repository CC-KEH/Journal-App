import 'package:flutter/material.dart';
import 'package:journal/Todo/todo_screen.dart';
import 'package:journal/components/bottom_navbar.dart';
import 'package:journal/Journal/home/home_screen.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void navigateBottomNavbar(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  final List<Widget> _pages = [
    //Journals
    const JournalScreen(),
    //Todos
    const TodoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2eadd),
      bottomNavigationBar: BottomNav(
        onTabChange: (index) => navigateBottomNavbar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
