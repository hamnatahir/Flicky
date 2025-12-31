import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/features/navigation/presentation/pages/home_bottombar.dart';
import 'package:flicky/features/navigation/presentation/pages/main_appbar.dart';
import 'package:flicky/features/navigation/presentation/pages/side_drawer.dart';
import 'package:flicky/features/landing/presentations/pages/home.page.dart';
import 'package:flicky/features/rooms/presentation/pages/rooms.page.dart';
import 'package:flicky/features/devices/presentation/pages/devices.page.dart';
import 'package:flicky/features/settings/presentation/pages/settings.page.dart';

class MainNavPage extends StatelessWidget {
  final Widget child;

  const MainNavPage({required this.child, super.key});

  int _indexFromLocation(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith(RoomsPage.route)) return 1;
    if (loc.startsWith(DevicesPage.route)) return 2;
    if (loc.startsWith(SettingsPage.route)) return 3;
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(HomePage.route);
        break;
      case 1:
        context.go(RoomsPage.route);
        break;
      case 2:
        context.go(DevicesPage.route);
        break;
      case 3:
        context.go(SettingsPage.route);
        break;
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final location = GoRouterState.of(context).uri.toString();

    if (!location.startsWith(HomePage.route)) {
      context.go(HomePage.route);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: const HomeAutomationAppBar(),
        drawer: const SideDrawer(),
        body: child,
        bottomNavigationBar: HomeAutomationBottomBar(
          currentIndex: currentIndex,
          onTabSelected: (i) => _onTabTap(context, i),
        ),
      ),
    );
  }
}
