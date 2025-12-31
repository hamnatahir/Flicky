import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/features/intro/presentation/pages/loading.page.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController heartbeatController;
  late AnimationController spreadController;
  late Animation<double> heartbeatScale;
  Animation<double>? spreadScale;

  bool showFinalHeartbeat = false; // final bolt flag

  @override
  void initState() {
    super.initState();

    heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    heartbeatScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: heartbeatController, curve: Curves.easeInOut),
    );

    spreadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final screenSize = MediaQuery.of(context).size;
      final diagonal = sqrt(
        screenSize.width * screenSize.width +
            screenSize.height * screenSize.height,
      );

      spreadScale = Tween<double>(begin: 1.0, end: diagonal / 75).animate(
        CurvedAnimation(parent: spreadController, curve: Curves.easeOut),
      );

      // Initial heartbeat for primary bolt
      heartbeatController.repeat(reverse: true);
      await Future.delayed(const Duration(seconds: 2));

      heartbeatController.stop();

      // Start spread AND immediately show final bolt
      setState(() {
        showFinalHeartbeat = true; // final bolt appears immediately
      });
      await spreadController.forward();

      // Keep heartbeat for final bolt
      heartbeatController.repeat(reverse: true);
      await Future.delayed(const Duration(seconds: 1));
      heartbeatController.stop();

      if (!mounted) return;
      GoRouter.of(context).go(LoadingPage.route);
    });
  }

  @override
  void dispose() {
    heartbeatController.dispose();
    spreadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light aur dark theme dono me foresty green shades
    final Color spreadColor = isDark ? const Color(0xFF3BD55B) : const Color(0xFF3BD55B);
    final Color finalBoltColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Spread circle
            if (spreadScale != null)
              AnimatedBuilder(
                animation: spreadController,
                builder: (_, __) {
                  return Transform.scale(
                    scale: spreadScale!.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: spreadColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            // Initial heartbeat bolt (primary)
            if (!showFinalHeartbeat)
              AnimatedBuilder(
                animation: heartbeatController,
                builder: (_, __) {
                  return Transform.scale(
                    scale: heartbeatScale.value,
                    child: Icon(
                      FlickyIcons.bolt,
                      size: 150,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            // Final bolt (white/dark) shown exactly when green spread starts
            if (showFinalHeartbeat)
              AnimatedBuilder(
                animation: heartbeatController,
                builder: (_, __) {
                  return Transform.scale(
                    scale: heartbeatScale.value,
                    child: Icon(
                      FlickyIcons.bolt,
                      size: 150,
                      color: finalBoltColor,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
