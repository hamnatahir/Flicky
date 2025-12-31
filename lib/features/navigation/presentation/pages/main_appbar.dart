import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/styles/style.dart';

class HomeAutomationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;

  const HomeAutomationAppBar({super.key, this.title});

  @override
  Size get preferredSize =>
      const Size.fromHeight(HomeAutomationStyles.appBarSize + 6);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor:
      theme.appBarTheme.backgroundColor ?? theme.colorScheme.background,
      elevation: 0,
      centerTitle: true,

      leading: context.canPop()
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.colorScheme.secondary,
        ),
        onPressed: () {
          context.pop();
        },
      )
          : null,

      title: title != null
          ? Text(
        title!,
        style: theme.textTheme.titleLarge!
            .copyWith(color: theme.colorScheme.primary),
      )
          : null,

      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.secondary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: HomeAutomationStyles.xsmallSize),
      ],
    );
  }
}
