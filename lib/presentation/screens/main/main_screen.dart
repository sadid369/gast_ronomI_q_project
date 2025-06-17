import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_navbar/custom_navbar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return CustomBottomNavBar(
      selectedIndex: navigationShell.currentIndex,
      onTap: _onTabTapped,
    );
  }

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
