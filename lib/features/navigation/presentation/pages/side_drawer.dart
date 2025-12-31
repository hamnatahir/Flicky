import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/styles/style.dart';

class SideMenuItem {
  final String label;
  final String route;

  SideMenuItem({
    required this.label,
    required this.route,
  });
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  List<SideMenuItem> get sideMenuItems => [
    SideMenuItem(
      label: 'About Flicky',
      route: '/about',
    ),
    SideMenuItem(
      label: 'My Home',
      route: '/landing',
    ),
    SideMenuItem(
      label: 'My Network',
      route: '/network',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).drawerTheme;

    return Drawer(
      child: Container(
        padding: HomeAutomationStyles.largePadding,
        color: theme.backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP FLICKY ICON (REMAIN)
              Icon(
                FlickyIcons.flickylight,
                size: HomeAutomationStyles.largeIconSize,
                color: theme.surfaceTintColor,
              ),

              HomeAutomationStyles.largeVGap,

              // MENU ITEMS (TEXT ONLY)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(sideMenuItems.length, (index) {
                    final item = sideMenuItems[index];
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(item.route);
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        item.label,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(
                          color: theme.surfaceTintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  })
                      .animate(interval: 200.ms)
                      .slideX(begin: -0.4, end: 0)
                      .fadeIn(),
                ),
              ),

              // BOTTOM FLICKY ICON
              Icon(
                FlickyIcons.flicky,
                size: HomeAutomationStyles.largeIconSize,
                color: theme.surfaceTintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
