import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNav extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNav({super.key,required this.onTabChange});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: GNav(
        onTabChange: (value)=> onTabChange!(value),
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.primary,
        tabActiveBorder: Border.all(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        gap: 10,
        tabs: const [
          //About
          GButton(
            icon: Icons.pentagon_rounded,
            text: 'Journal',
          ),
          //Shop
          GButton(
            icon: Icons.pentagon_outlined,
            text: 'Todo',
          ),
        ],
      ),
    );
  }
}
