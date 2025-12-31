import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/features/landing/presentations/pages/home.page.dart';
import 'package:flicky/features/settings/presentation/pages/login.page.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/settings/presentation/providers/user_provider.dart';

class LoadingPage extends StatefulWidget {
  static const String route = '/loading';
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoadingSequence();
    });
  }

  Future<void> _startLoadingSequence() async {
    setState(() => loadingText = 'Initializing...');
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => loadingText = 'Loading...');
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => loadingText = 'Almost done...');
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => loadingText = 'Done');
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final userProvider =
    Provider.of<UserProvider>(context, listen: false);

    final router = GoRouter.of(context);

    if (userProvider.isLoggedIn) {
      router.go(HomePage.route);
    } else {
      router.go(LoginPage.route);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Icon(
                FlickyIcons.flickylogo,
                size: 230,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loadingText,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
