import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/landing/presentations/pages/main_page_header.dart';
import 'package:flicky/features/settings/presentation/providers/user_provider.dart';
import 'package:flicky/features/settings/presentation/pages/login.page.dart';
import 'package:flicky/styles/flicky_icon_icons.dart';
import 'package:flicky/styles/style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  static const String route = '/settings';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainPageHeader(
                icon: Icon(
                  FlickyIcon.cog_alt,
                  size: HomeAutomationStyles.largeIconSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: 'My Settings',
              ).animate()
                  .slideX(begin: 0.5, end: 0, duration: const Duration(milliseconds: 500))
                  .fadeIn(duration: const Duration(milliseconds: 500)),
              HomeAutomationStyles.mediumVGap,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (userProvider.isLoggedIn) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx), // only close dialog
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () async {
                                      await userProvider.logout(); // logout
                                      Navigator.pop(ctx); // close dialog
                                      GoRouter.of(context).go(LoginPage.route); // redirect safely
                                    },
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            GoRouter.of(context).go(LoginPage.route); // not logged in
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                FlickyIcon.user_alt,
                                size: 28,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
