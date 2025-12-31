import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {

    // Simple static text instead of localization provider
    const String welcomeLabel = 'Welcome';
    const String userName = 'Hamna';

    return Padding(
      padding: HomeAutomationStyles.mediumPadding.copyWith(
        bottom: 0,
        left: HomeAutomationStyles.mediumSize,
      ),
      child: Row(
        children: [
          // Bolt icon
          const Icon(
            FlickyIcons.bolt,
            size: HomeAutomationStyles.largeIconSize,
            color: Colors.amber, // temporary color, can adjust with theme
          ),

          HomeAutomationStyles.mediumHGap,

          // Welcome text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$welcomeLabel,',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                userName,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ].animate(
              interval: 300.ms,
            ).slideX(
              begin: 0.5, end: 0,
              duration: 0.5.seconds,
              curve: Curves.easeInOut,
            ).fadeIn(
              duration: 0.5.seconds,
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
