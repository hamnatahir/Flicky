import 'package:flutter/material.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';

class WarningMessage extends StatelessWidget {
  final String message;
  const WarningMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FlickyIcons.flickylight, size: 60, color: Colors.grey),
          HomeAutomationStyles.largeVGap,
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
