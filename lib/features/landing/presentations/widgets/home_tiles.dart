import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flicky/styles/style.dart';
import 'package:flicky/styles/flicky_icon_icons.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/features/devices/presentation/widgets/add_device_sheet.dart';
import 'package:flicky/features/devices/presentation/models/outlet.model.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/devices/presentation/providers/device_list_state.dart';
import 'package:flicky/features/rooms/presentation/providers/room_list_state.dart';
import 'package:flicky/features/rooms/presentation/widgets/add_room_sheet.dart';
import 'package:flicky/helpers/utils.dart';

class HomeTileOption {
  final String id;
  final String title;
  final IconData icon;

  HomeTileOption({required this.id, required this.title, required this.icon});
}

final List<HomeTileOption> homeTiles = [
  HomeTileOption(id: 'add_device', title: 'Add New Devices', icon: FlickyIcon.widgets),
  HomeTileOption(id: 'add_rooms', title: 'Add New Rooms', icon: FlickyIcons.room),
  HomeTileOption(id: 'test_connection', title: 'Test Connection', icon: FlickyIcon.wifi_tethering),
];

class HomeTilesRow extends StatelessWidget {
  final List<OutletModel> outletList;

  const HomeTilesRow({required this.outletList, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomeAutomationStyles.mediumPadding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homeTiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final tile = homeTiles[index];
          return Material(
            borderRadius: BorderRadius.circular(HomeAutomationStyles.mediumRadius),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.18),
            child: InkWell(
              borderRadius: BorderRadius.circular(HomeAutomationStyles.mediumRadius),
              onTap: () {
                if (tile.id == 'add_device') {
                  Utils.showUIModal(
                    context,
                    AddDeviceSheet(
                      outletList: outletList,
                      onSave: (device) {
                        Provider.of<DeviceListState>(context, listen: false)
                            .addDevice(device);
                      },
                    ),
                    dismissible: true,
                  );
                } else if (tile.id == 'add_rooms') {
                  Utils.showUIModal(
                    context,
                    const AddRoomSheet(),
                    dismissible: true,
                  );
                } else if (tile.id == 'test_connection') {
                  // Optional: handle test connection tap
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tile.icon,
                    size: HomeAutomationStyles.mediumIconSize + 8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  HomeAutomationStyles.mediumVGap,
                  Text(
                    tile.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(
            delay: (index * 0.125).seconds,
          )
              .slideY(begin: 0.5, end: 0, duration: 0.5.seconds)
              .fadeIn(duration: 0.5.seconds);
        },
      ),
    );
  }
}
