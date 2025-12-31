import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flicky/routers/app.routes.dart';
import 'package:flicky/styles/themes.dart';
import 'package:flicky/features/devices/presentation/providers/device_list_state.dart';
import 'package:flicky/features/rooms/presentation/providers/room_list_state.dart';
import 'package:flicky/features/settings/presentation/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceListState()),
        ChangeNotifierProvider(create: (_) => RoomListState()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const HomeAutomationApp(),
    ),
  );
}

class HomeAutomationApp extends StatelessWidget {
  const HomeAutomationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: HomeAutomationTheme.light,
      darkTheme: HomeAutomationTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routerDelegate: AppRoutes.router.routerDelegate,
    );
  }
}
