import 'package:flutter/material.dart';
import 'package:flicky/styles/style.dart';

class MainPageHeader extends StatelessWidget {
  final Icon icon;
  final String title;

  const MainPageHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomeAutomationStyles.mediumPadding,
      child: Row(
        children: [
          icon,
          HomeAutomationStyles.mediumHGap,
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
