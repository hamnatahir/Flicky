import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/devices_list.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/styles/flicky_icon_icons.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/features/landing/presentations/pages/main_page_header.dart';
import 'package:flicky/features/devices/presentation/providers/device_list_state.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});
  static const String route = '/devices';

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DeviceListState>(context, listen: false).loadDevices();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DeviceListState>(context, listen: false).loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainPageHeader(
          icon: Icon(
            FlickyIcon.widgets,
            size: HomeAutomationStyles.largeIconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: 'My Devices',
        ).animate()
            .slideX(begin: 0.5, end: 0, duration: 500.ms)
            .fadeIn(duration: 500.ms),
        HomeAutomationStyles.mediumVGap,
        Expanded(
          child: Consumer<DeviceListState>(
            builder: (context, deviceState, _) {
              final devices = deviceState.devices;
              final docIds = deviceState.docIds;

              if (devices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FlickyIcons.outlet, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No available devices',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return DevicesList(
                devices: devices,
                docIds: docIds,
              );
            },
          ),
        ),
      ],
    );
  }
}
