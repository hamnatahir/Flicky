import 'package:flutter/material.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/styles/flicky_icon_icons.dart';

class HomeAutomationBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const HomeAutomationBottomBar({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: theme.colorScheme.background,
      elevation: 0, // removes shadow
      onTap: onTabSelected,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FlickyIcon.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FlickyIcons.room),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(FlickyIcon.widgets),
          label: 'Devices',
        ),
        BottomNavigationBarItem(
          icon: Icon(FlickyIcon.cog_alt),
          label: 'Settings',
        ),
      ],
    );
  }
}
