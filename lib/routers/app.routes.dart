import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/devices/presentation/pages/device_details_page.dart';
import 'package:flicky/features/devices/presentation/pages/devices.page.dart';
import 'package:flicky/features/intro/presentation/pages/loading.page.dart';
import 'package:flicky/features/intro/presentation/pages/splash.page.dart';
import 'package:flicky/features/landing/presentations/pages/home.page.dart';
import 'package:flicky/features/landing/presentations/pages/main_nav.page.dart';
import 'package:flicky/features/rooms/presentation/pages/rooms.page.dart';
import 'package:flicky/features/settings/presentation/pages/settings.page.dart';
import 'package:flicky/features/settings/presentation/pages/login.page.dart';
import 'package:flicky/features/settings/presentation/pages/signup.page.dart';
import 'package:flicky/helpers/utils.dart';
import '../features/devices/presentation/models/device.model.dart';
import 'package:flicky/features/devices/presentation/providers/device_list_state.dart';
import 'package:flicky/features/settings/presentation/providers/user_provider.dart';

class AppRoutes {
  static final router = GoRouter(
    routerNeglect: true,
    initialLocation: SplashPage.route,
    navigatorKey: Utils.mainNav,

    redirect: (context, state) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final path = state.uri.path;

      // Allow Splash & Loading always
      if (path == SplashPage.route || path == LoadingPage.route) return null;

      final onAuthPage = path == LoginPage.route || path == SignUpPage.route;

      // User NOT logged in
      if (!userProvider.isLoggedIn) {
        if (onAuthPage) return null; // allow login/signup
        return LoginPage.route; // block everything else
      }

      // User logged in → prevent going back to login/signup
      if (userProvider.isLoggedIn && onAuthPage) return HomePage.route;

      return null; // no redirect
    },

    routes: [
      // Splash Page
      GoRoute(
        parentNavigatorKey: Utils.mainNav,
        path: SplashPage.route,
        builder: (_, __) => const SplashPage(),
      ),

      // Loading Page
      GoRoute(
        parentNavigatorKey: Utils.mainNav,
        path: LoadingPage.route,
        builder: (_, __) => const LoadingPage(),
      ),

      // Login Page
      GoRoute(
        parentNavigatorKey: Utils.mainNav,
        path: LoginPage.route,
        builder: (_, __) => const LoginPage(),
      ),

      // SignUp Page
      GoRoute(
        parentNavigatorKey: Utils.mainNav,
        path: SignUpPage.route,
        builder: (_, __) => const SignUpPage(),
      ),

      // Main Shell
      ShellRoute(
        navigatorKey: Utils.tabNav,
        builder: (context, state, child) => MainNavPage(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: HomePage.route,
            pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: RoomsPage.route,
            pageBuilder: (_, __) => const NoTransitionPage(child: RoomsPage()),
          ),
          GoRoute(
            path: DevicesPage.route,
            pageBuilder: (_, __) => const NoTransitionPage(child: DevicesPage()),
          ),
          GoRoute(
            path: SettingsPage.route,
            pageBuilder: (_, __) => const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),

      // Device Details
      GoRoute(
        parentNavigatorKey: Utils.mainNav,
        path: DeviceDetailsPage.route,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null || extra['device'] == null || extra['docId'] == null) {
            return const Scaffold(
              body: Center(child: Text('No device selected')),
            );
          }

          final device = extra['device'] as DeviceModel;
          final docId = extra['docId'] as String;

          return DeviceDetailsPage(
            device: device,
            docId: docId,
            onDeleted: () {
              Provider.of<DeviceListState>(context, listen: false).loadDevices();
            },
          );
        },
      ),
    ],
  );
}
