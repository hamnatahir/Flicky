import 'package:flutter/material.dart';
import 'package:flicky/features/landing/presentations/pages/home_page_header.dart';
import 'package:flicky/features/landing/presentations/widgets/home_tiles.dart';
import 'package:flicky/features/devices/presentation/models/outlet.model.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/features/navigation/presentation/pages/side_drawer.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<OutletModel> outletList = [];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomePageHeader(),
              HomeAutomationStyles.mediumVGap,
              HomeTilesRow(outletList: outletList),
            ],
          ),
        ),
      ),
    );
  }
}
